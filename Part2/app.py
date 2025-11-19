from flask import Flask, flash, redirect, render_template, request, jsonify, url_for, session
import config
import pymysql
import random

# NOTE THIS DOES NOT CONTAIN THE REQUIRED ENVIRONMENT TO RUN
# INSTALL FLASK AND PYMYSQL AS REQUIRED BY PROF...

db = config.db1
app = Flask(__name__)
app.secret_key = config.SECRET_KEY

#Zone to add more


@app.route('/')
def returnHome():
    return render_template('index.html', user=session.get('username'))

@app.route('/login', methods = ['POST', 'GET'])
def loginPage():
    cursor=db.cursor()

    if request.method=='POST':
        if request.form.get('action') == "LOGIN":
            username = request.form.get('loginUser')
            password = request.form.get('loginPass')

            if not username or not password:
                flash('Invalid Credentials', 'danger')
                return redirect(url_for('loginPage'))

            sql = "SELECT userID, username, password, permission_level FROM users where username=%s AND AES_DECRYPT(password, UNHEX(%s)) = %s"
            cursor.execute(sql, (username, config.SECRET_KEY, password))
            tempUser = cursor.fetchall()

            cursor.close()
            cursor = db.cursor()

            if not tempUser:
                flash('Login not Found', 'danger')
                return redirect(url_for('loginPage'))
            
            session['ID'] = tempUser[0][0]
            session['username'] = tempUser[0][1]
            session['permission'] = tempUser[0][3]

            if session.get('permission') == 1:
                sql = "SELECT count(ID) FROM student WHERE advisor_id = %s"
                cursor.execute(sql, (session.get('ID'),))
                session['advisingCount'] = cursor.fetchone()[0]

                sql = "SELECT salary, dept_name FROM instructor WHERE ID = %s"
                cursor.execute(sql, (session.get('ID'),))
            elif session.get('permission') == 0:
                sql = "SELECT tot_credits, advisor_id FROM student WHERE ID = %s"
                cursor.execute(sql, (session.get('ID'),))
            else:
                flash('Successfully Logged In', 'success')
                return redirect(url_for('returnHome'))

            extraData = cursor.fetchall()
            if extraData:
                if session.get('permission') == 1:
                    session['salary'] = extraData[0][0]
                    session['dept_name'] = extraData[0][1]
                else:
                    session['tot_credits'] = extraData[0][0]
                    session['advisor_id'] = extraData[0][1]


            flash('Successfully Logged In', 'success')

            return redirect(url_for('returnHome'))
        elif request.form.get('action') == "REGISTER":
            username = request.form.get('registerUser')
            password = request.form.get('registerPass')
            permission = 1 if request.form.get('registerPermission') else 0
            table = 'instructor' if permission == 1 else 'student'
            userID = getRandomID(table)

            sql = "SELECT * FROM users WHERE username = %s"
            cursor.execute(sql, (username,))
            if cursor.fetchall():
                flash('User already Exists', 'warning')
                return redirect(url_for('loginPage'))

            sql = "INSERT INTO users(username, password, permission_level, userID) VALUES (%s, AES_ENCRYPT(%s, UNHEX(%s)), %s, %s)"
            cursor.execute(sql, (username, password, config.SECRET_KEY, permission, userID,))

            if (table == 'student'):
                sql = "INSERT INTO student (ID, name, tot_credits) VALUES (%s, %s, 0)"
                cursor.execute(sql, (userID, username,))
            else:
                sql = "INSERT INTO instructor (ID, name, salary, dept_name) VALUES (%s, %s, 0, NULL)"
                cursor.execute(sql, (userID, username,))
            db.commit()

            flash('User successfully created!', 'success')

    cursor.close()
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out', 'info')
    return redirect(url_for('returnHome'))

@app.route('/dashboard')
def goToDash():
    #Admin
    if session.get('permission') == 2:
        return redirect(url_for('adminPage'))
    
    #Instructor
    elif session.get('permission') == 1:
        return redirect(url_for('instructorPage', configuration = 0))
    
    #Student
    else:
        return redirect(url_for('studentPage'))
    
@app.route('/instructor', methods = ['GET', 'POST'])
def instructorPage():
    
    cursor = db.cursor()
    
    configuration = request.args.get('configuration', 0, type=int)

    if request.method == 'POST':

        configuration = int(request.form.get('config'))


        if configuration == 0:
            if session.get('salary') == 0:
                flash('Please input your salary', 'warning')
            if session.get('dept_name') == None:
                flash('Please select your department', 'warning')

        ac = request.form.get('action')

        #Changing 'configuration'
        if ac == 'switchConfig':
            configuration = request.form.get('configVal')
            #If looking for advising
        

        #Changing department
        if ac == 'newDept':
            newDept = request.form.get('newDept')
            session['dept_name'] = newDept
            sql = "UPDATE instructor SET dept_name = %s WHERE ID = %s"
            cursor.execute(sql, (newDept, session.get('ID'),))
            db.commit()
            
        
        #Changing salary
        if ac == 'newSalary':
            newSalary = request.form.get('newSalary')
            session['salary'] = newSalary
            sql = "UPDATE instructor SET salary = %s WHERE ID = %s"
            cursor.execute(sql, (newSalary, session.get('ID'),))
            db.commit()

        #Filtering sections
        if ac == 'filter':
            f = request.form.get('filter')
            if f != "None":
                f = f.split(',')
                print(f[0])
                sql = "SELECT course_id, semester, year, building, room_number, day, start_hr, start_min, end_hr, end_min, sec_id FROM section JOIN time_slot ON section.time_slot_id=time_slot.time_slot_id WHERE teacher=%s AND semester=%s AND year=%s"
                cursor.execute(sql, (session.get('ID'), f[0], f[1]))
                session['tableData'] = cursor.fetchall()
                return render_template('instructorDash.html', randMsg = randMsg, departments=getDepts(), configuration=1, getSems=getTaughtSemesters)
                
            else:
                configuration = 1
                sql = "SELECT course_id, semester, year, building, room_number, day, start_hr, start_min, end_hr, end_min, sec_id FROM section JOIN time_slot ON section.time_slot_id=time_slot.time_slot_id WHERE teacher=%s"
                cursor.execute(sql, (session.get('ID'),))
                session['tableData'] = cursor.fetchall()
        
        #Listing Sec
        if ac == 'listSec':
            session['course'] = request.form.get('courseID')
            session['section'] = request.form.get('sectionID')

        #Changing Grade
        if ac == 'newGrade':
            ID = request.form.get('studentID')
            course = request.form.get('courseID')
            sec = request.form.get('secID')
            val = convertToGrade(request.form.get('newGrade'))
            sql = "UPDATE takes SET grade = %s WHERE ID = %s AND course_id = %s AND sec_id = %s"
            cursor.execute(sql, (val, ID, course, sec,))
            db.commit()

        #Submitting Grade
        if ac == 'submitGrade':
            vals = request.form.get('gradeSubmit').split(',')
            sql = "UPDATE takes SET submit = 1 WHERE ID = %s AND course_id = %s AND sec_id = %s"
            cursor.execute(sql, (vals[0],vals[1],vals[2],))
            db.commit()

        if ac == 'removeStudent':
            vals = request.form.get('removeStudent').split(',')
            sql = "DELETE FROM takes WHERE ID = %s AND course_id = %s AND sec_id = %s"
            cursor.execute(sql, (vals[0],vals[1],vals[2],))
            db.commit()

        if configuration == 0:
            sql = "SELECT ID, name, tot_credits FROM student WHERE advisor_id = %s"
            cursor.execute(sql, (session.get('ID'),))
            session['tableData'] = cursor.fetchall()
        elif configuration == 1:
            sql = "SELECT course_id, semester, year, building, room_number, day, start_hr, start_min, end_hr, end_min, sec_id FROM section JOIN time_slot ON section.time_slot_id=time_slot.time_slot_id WHERE teacher=%s"
            cursor.execute(sql, (session.get('ID'),))
            session['tableData'] = cursor.fetchall()
        if configuration == 2:
            sql = "SELECT student.ID, name, grade, course_id, sec_id, submit FROM takes JOIN student ON student.ID = takes.ID WHERE course_id = %s AND sec_id = %s"
            cursor.execute(sql, (session.get('course'), session.get('section')))
            session['tableData'] = cursor.fetchall()
            print('redo')
        #END OF POST

    #NOT POST
    if configuration == 0:
        sql = "SELECT ID, name, tot_credits FROM student WHERE advisor_id = %s"
        cursor.execute(sql, (session.get('ID'),))
        session['tableData'] = cursor.fetchall()
    elif configuration == 1:
        sql = "SELECT course_id, semester, year, building, room_number, day, start_hr, start_min, end_hr, end_min, sec_id FROM section JOIN time_slot ON section.time_slot_id=time_slot.time_slot_id WHERE teacher=%s"
        cursor.execute(sql, (session.get('ID'),))
        session['tableData'] = cursor.fetchall()
    if configuration == 2 :
        sql = "SELECT student.ID, name, grade, course_id, sec_id, submit FROM takes JOIN student ON student.ID = takes.ID WHERE course_id = %s AND sec_id = %s"
        cursor.execute(sql, (session.get('course'), session.get('section')))
        session['tableData'] = cursor.fetchall()

    cursor.close()
    return render_template('instructorDash.html', randMsg = randMsg, departments=getDepts(), configuration=configuration, getSems=getTaughtSemesters)

@app.route('/advising', methods=['POST'])
def instructorAdvising():
    
    cursor = db.cursor()
    action = request.form.get('action')
    ID = request.form.get('ID')
    if action == 'Add':

        sql = "SELECT ID FROM student WHERE ID = %s"
        cursor.execute(sql, (ID,))
        if cursor.fetchone():
            sql = "UPDATE student SET advisor_id = %s WHERE ID = %s"
            cursor.execute(sql, (session.get('ID'), ID,))
            db.commit()
        else:
            flash("Could not find student", 'warning')
    elif action == 'Remove':
        sql = "SELECT ID FROM student WHERE advisor_id = %s AND ID = %s"
        cursor.execute(sql, (session.get('ID'), ID,))
        if cursor.fetchone():
            sql = "UPDATE student SET advisor_id = NULL WHERE advisor_id = %s AND ID = %s"
            cursor.execute(sql, (session.get('ID'), ID,))
            db.commit()
        else:
            flash('Not Advising student', 'warning')

    session.pop('tableData')

    cursor.close()
    return redirect(url_for('instructorPage'))

@app.route('/student')
def studentPage():
    return render_template('studentDash.html')

@app.route('/admin')
def adminPage():
    return render_template('adminDash.html')



def getRandomID(table):
    val = 10000
    sql = "SELECT name FROM %s WHERE ID = %s"
    cursor.execute(sql, (table, val,))
    data = cursor.fetchall()

    while data:
        val += 1
        cursor.execute(sql, (val,))
        data = cursor.fetchall()
        
    return val

def randMsg():
    msg = ["Welcome", "Hello", "Welcome Back", "Hello Again"]
    return random.choice(msg)

def getDepts():
    cursor = db.cursor()
    sql = "SELECT dept_name FROM department"
    cursor.execute(sql)
    return cursor.fetchall()

def getTaughtSemesters():
    cursor = db.cursor()
    sql = "SELECT semester, year FROM section WHERE teacher = %s"
    cursor.execute(sql, (session.get('ID')))
    return cursor.fetchall()

def convertToGrade(val):
    val = int(val)
    if val < 60:
        return "F"
    elif 60 <= val <= 62:
        return "D-"
    elif 63 <= val <= 66:
        return "D"
    elif 67 <= val <= 69:
        return "D+"
    elif 70 <= val <= 72:
        return "C-"
    elif 73 <= val <= 76:
        return "C"
    elif 77 <= val <= 79:
        return "C+"
    elif 80 <= val <= 82:
        return "B-"
    elif 83 <= val <= 86:
        return "B"
    elif 87 <= val <= 89:
        return "B+"
    elif 90 <= val <= 92:
        return "A-"
    elif 93 <= val <= 96:
        return "A"
    elif 97 <= val <= 100:
        return "A+"
    return "F"


if __name__ == '__main__':
    cursor=db.cursor()
    app.run()