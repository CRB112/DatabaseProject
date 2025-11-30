from flask import Flask, flash, redirect, render_template, request, jsonify, url_for, session
import config
import pymysql
import random
import atexit

# NOTE: THIS DOES NOT CONTAIN THE REQUIRED ENVIRONMENT TO RUN
# INSTALL FLASK AND PYMYSQL AS REQUIRED BY PROF...

db = config.db1
app = Flask(__name__)
app.secret_key = config.SECRET_KEY

# -------------------------------------------------------------------------
# For Home, Login, Logout, and Dashboard Redirection
# -------------------------------------------------------------------------

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

# -------------------------------------------------------------------------
# For Instructor Dashboard Page
# -------------------------------------------------------------------------

@app.route('/instructor', methods = ['GET', 'POST'])
def instructorPage():
    
    cursor = db.cursor()
    configuration = request.args.get('configuration', 0, type=int)
    classSemAvg = session.pop('classSemAvg', None)
    bestWorst = session.pop('bestWorst', None)
    session.setdefault('stats', {})

    def get_table_data(configuration):
        if configuration == 0:
            sql = "SELECT ID, name, tot_credits FROM student WHERE advisor_id = %s"
            cursor.execute(sql, (session.get('ID'),))
            session['tableData'] = cursor.fetchall()
        elif configuration == 1:
            sql = "SELECT course_id, semester, year, building, room_number, day, start_hr, start_min, end_hr, end_min, sec_id FROM section JOIN time_slot ON section.time_slot_id=time_slot.time_slot_id WHERE teacher=%s"
            cursor.execute(sql, (session.get('ID'),))
            session['tableData'] = cursor.fetchall()
        elif configuration == 2:
            sql = "SELECT student.ID, name, grade, course_id, sec_id, submit FROM takes JOIN student ON student.ID = takes.ID WHERE course_id = %s AND sec_id = %s"
            cursor.execute(sql, (session.get('course'), session.get('section')))
            session['tableData'] = cursor.fetchall()
        sql = "SELECT course_id FROM course"
        cursor.execute(sql)
        session['allClasses'] = cursor.fetchall()

        cursor.callproc('get_all_semesters_and_years')
        session['classSems'] = cursor.fetchall()
        
        cursor.callproc('get_avg_grade_by_dept_param', [session.get('dept_name')])
        if cursor.rowcount > 0:
            session['stats']['deptAvg'] = cursor.fetchall()[0][0]
        else:
            session['stats']['deptAvg'] = "N/A"
        
        cursor.callproc('get_total_students_by_dept', [session.get('dept_name')])
        if cursor.rowcount > 0:
             session['stats']['deptStudents'] = cursor.fetchall()[0][0]
        else:
             session['stats']['deptStudents'] = 0

        cursor.callproc('get_total_current_students_by_dept', [session.get('dept_name')])
        if cursor.rowcount > 0:
            session['stats']['deptStudentsEnrolled'] = cursor.fetchall()[0][0]
        else:
             session['stats']['deptStudentsEnrolled'] = 0

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

        #Submitting all Grades
        if ac == 'submitGradeAll':
            flag = False
            for row in session.get('tableData'):
                if row[2] == None:
                    flag = True
            if not flag:
                sql = "UPDATE takes SET submit = 1 WHERE ID = %s AND course_id = %s AND sec_id = %s"
                cid = session.get('course')
                sec = session.get('section')
                for row in session.get('tableData'):
                    cursor.execute(sql, (row[0], cid, sec,))
                db.commit()

        #Remove Student From Sec
        if ac == 'removeStudent':
            vals = request.form.get('removeStudent').split(',')
            sql = "DELETE FROM takes WHERE ID = %s AND course_id = %s AND sec_id = %s"
            cursor.execute(sql, (vals[0],vals[1],vals[2],))
            db.commit()

        #Changing Prereq
        if ac == 'newPrereq':
            p = request.form.get('newPrereq')
            if p == "NULL":
                p = None
            sql = "UPDATE course SET prereq = %s WHERE course_id = %s"
            cursor.execute(sql, (p, session.get('course'),))
            db.commit()


    get_table_data(configuration)
    cursor.close()
    return render_template('instructorDash.html', randMsg = randMsg, departments=getDepts(), configuration=configuration, getSems=getTaughtSemesters, classSemAvg = classSemAvg, bestWorst=bestWorst)

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

@app.route('/avgGradeRange', methods=['POST'])
def avg():
    cursor = db.cursor()

    min_sem, min_year = request.form.get('minSem').split(',')
    max_sem, max_year = request.form.get('maxSem').split(',')
    c = request.form.get('courseChoose')

    if int(max_year) < int(min_year):
        flash('Invalid Parameters', 'warning')
        cursor.close()
        return redirect(url_for('instructorPage'))

    sql = "CALL get_avg_grade_for_class_across_semesters(%s, %s, %s, %s, %s)"
    cursor.execute(sql, (c, min_sem, int(min_year), max_sem, int(max_year)))
    avg = cursor.fetchall()
    cursor.close()

    if not avg or avg[0][0] is None:
        flash('Classes Do not Exist in Range', 'warning')
        return redirect(url_for('instructorPage'))

    session['classSemAvg'] = (
        c,
        (min_sem, min_year),
        (max_sem, max_year),
        float(avg[0][0])
    )
    return redirect(url_for('instructorPage', configuration = 1))

@app.route('/bestWorstClass', methods=['POST'])
def bestWorst():
    cursor = db.cursor()

    # Get the selected semester and year from the form input
    sem = request.form.get('bestWorst').split(',')

    # Call the stored procedure with the semester and year
    cursor.callproc('get_best_and_worst_classes', [sem[0], int(sem[1])])

    res = cursor.fetchall()

    session['bestWorst'] = (
        (res[0][0], res[0][1]),
        (res[0][2], float(res[0][3])),
        (res[0][4], float(res[0][5]))
    )

    return redirect(url_for('instructorPage', configuration = 1))


# -------------------------------------------------------------------------
# For Student Dashboard Page
# -------------------------------------------------------------------------

@app.route('/student', methods=['GET', 'POST'])
def studentPage():
    # Check permission
    if session.get('permission') != 0:
        return redirect(url_for('returnHome'))

    cursor = db.cursor()
    configuration = request.args.get('configuration', 0, type=int) # 0=My Classes, 1=Registration, 2=Profile
    session.setdefault('studentData', {})

    # Helper to refresh data
    def refresh_student_data():
        # 1. Get Enrolled Classes
        # FIXED: Changed s.day, s.start_hr, etc. to ts.day, ts.start_hr, etc.
        sql = """
            SELECT t.course_id, t.sec_id, t.semester, t.year, t.grade, 
                   ts.day, ts.start_hr, ts.start_min, ts.end_hr, ts.end_min, c.credits, i.name, s.room_number, s.building, t.submit
            FROM takes t
            JOIN section s ON t.course_id = s.course_id AND t.sec_id = s.sec_id AND t.semester = s.semester AND t.year = s.year
            JOIN course c ON t.course_id = c.course_id
            JOIN instructor i ON s.teacher = i.ID
            JOIN time_slot ts ON s.time_slot_id = ts.time_slot_id
            WHERE t.ID = %s
        """
        cursor.execute(sql, (session.get('ID'),))
        session['enrolledClasses'] = cursor.fetchall()

        # 2. Get Available Sections
        sql = """
            SELECT s.course_id, s.sec_id, s.semester, s.year, c.title, i.name, 
                   ts.day, ts.start_hr, ts.start_min, ts.end_hr, ts.end_min
            FROM section s
            JOIN course c ON s.course_id = c.course_id
            JOIN instructor i ON s.teacher = i.ID
            JOIN time_slot ts ON s.time_slot_id = ts.time_slot_id
            WHERE (s.course_id, s.sec_id, s.semester, s.year) NOT IN (
                SELECT course_id, sec_id, semester, year FROM takes WHERE ID = %s
            )
        """
        cursor.execute(sql, (session.get('ID'),))
        session['availableSections'] = cursor.fetchall()

        # 3. Get Advisor Info
        sql = "SELECT i.name, i.dept_name, i.ID FROM student s JOIN instructor i ON s.advisor_id = i.ID WHERE s.ID = %s"
        cursor.execute(sql, (session.get('ID'),))
        session['advisorInfo'] = cursor.fetchone()

        # 4. Get Student Personal Info
        sql = "SELECT name, tot_credits FROM student WHERE ID = %s"
        cursor.execute(sql, (session.get('ID'),))
        session['personalInfo'] = cursor.fetchone()

    if request.method == 'POST':
        action = request.form.get('action')
        # Only update config if it's passed, otherwise keep current
        if request.form.get('config'):
            configuration = int(request.form.get('config'))

        if action == 'register':
            cid = request.form.get('courseID')
            sid = request.form.get('secID')
            sem = request.form.get('semester')
            yr = request.form.get('year')
            try:
                sql = "INSERT INTO takes (ID, course_id, sec_id, semester, year, grade, submit) VALUES (%s, %s, %s, %s, %s, '', 0)"
                cursor.execute(sql, (session.get('ID'), cid, sid, sem, yr))
                db.commit()
                flash(f'Successfully registered for {cid}', 'success')
            except Exception as e:
                flash(f'Error registering: {e}', 'danger')

        elif action == 'drop':
            cid = request.form.get('courseID')
            sid = request.form.get('secID')
            sem = request.form.get('semester')
            yr = request.form.get('year')
            try:
                sql = "DELETE FROM takes WHERE ID=%s AND course_id=%s AND sec_id=%s AND semester=%s AND year=%s"
                cursor.execute(sql, (session.get('ID'), cid, sid, sem, yr))
                db.commit()
                flash(f'Dropped {cid}', 'warning')
            except Exception as e:
                flash('Error dropping class', 'danger')

        elif action == 'updateProfile':
            newName = request.form.get('newName')
            try:
                sql = "UPDATE student SET name = %s WHERE ID = %s"
                cursor.execute(sql, (newName, session.get('ID')))
                # Update users table for login consistency
                sql_user = "UPDATE users SET username = %s WHERE userID = %s"
                cursor.execute(sql_user, (newName, session.get('ID')))
                session['username'] = newName
                db.commit()
                flash('Profile Updated', 'success')
            except Exception as e:
                 flash(f'Error updating profile: {e}', 'danger')

    refresh_student_data()
    cursor.close()
    return render_template('studentDash.html', configuration=configuration)

# -------------------------------------------------------------------------
# For Admin Dashboard Page
# -------------------------------------------------------------------------

@app.route('/admin', methods=['GET', 'POST'])
def adminPage():
    if session.get('permission') != 2:
        return redirect(url_for('returnHome'))

    cursor = db.cursor()
    configuration = request.args.get('configuration', 0, type=int) 
    
    def refresh_admin_data(config):
        session['adminData'] = []
        if config == 0: # Course
            cursor.execute("SELECT * FROM course")
        elif config == 1: # Section
            cursor.execute("SELECT * FROM section")
        elif config == 2: # Instructor
            cursor.execute("SELECT * FROM instructor")
        elif config == 3: # Student
            cursor.execute("SELECT * FROM student")
        elif config == 4: # Department
            cursor.execute("SELECT * FROM department")
        elif config == 5: # Classroom
            cursor.execute("SELECT * FROM classroom")
        elif config == 6: # Time Slot
            cursor.execute("SELECT * FROM time_slot")
        
        session['adminData'] = cursor.fetchall()

        cursor.execute("SELECT dept_name FROM department")
        session['allDepts'] = cursor.fetchall()
        cursor.execute("SELECT building FROM building")
        session['allBuildings'] = cursor.fetchall()

    if request.method == 'POST':
        action = request.form.get('action')
        if request.form.get('config'):
            configuration = int(request.form.get('config'))
        
        try:
            # --- COURSE CRUD ---
            if configuration == 0:
                if action == 'add':
                    cursor.execute("INSERT INTO course (course_id, title, dept_name, credits) VALUES (%s, %s, %s, %s)", 
                                   (request.form.get('id'), request.form.get('title'), request.form.get('dept'), request.form.get('credits')))
                elif action == 'delete':
                    cursor.execute("DELETE FROM course WHERE course_id=%s", (request.form.get('id'),))

            # --- SECTION CRUD ---
            elif configuration == 1:
                if action == 'add':
                    cursor.execute("INSERT INTO section (course_id, sec_id, semester, year, teacher, building, room_number, time_slot_id) VALUES (%s, %s, %s, %s, %s, NULL, NULL, 'A')",
                                   (request.form.get('cid'), request.form.get('sid'), request.form.get('sem'), request.form.get('year'), request.form.get('tid')))
                elif action == 'delete':
                    cursor.execute("DELETE FROM section WHERE course_id=%s AND sec_id=%s AND semester=%s AND year=%s",
                                   (request.form.get('cid'), request.form.get('sid'), request.form.get('sem'), request.form.get('year')))
                elif action == 'updateTeacher': 
                    cursor.execute("UPDATE section SET teacher=%s WHERE course_id=%s AND sec_id=%s AND semester=%s AND year=%s",
                                   (request.form.get('tid'), request.form.get('cid'), request.form.get('sid'), request.form.get('sem'), request.form.get('year')))

            # --- INSTRUCTOR CRUD ---
            elif configuration == 2:
                if action == 'add':
                    uid = request.form.get('id')
                    cursor.execute("INSERT INTO instructor (ID, name, dept_name, salary) VALUES (%s, %s, %s, %s)",
                                   (uid, request.form.get('name'), request.form.get('dept'), request.form.get('salary')))
                    cursor.execute("INSERT INTO users (userID, username, password, permission_level) VALUES (%s, %s, AES_ENCRYPT(%s, UNHEX(%s)), 1)",
                                   (uid, request.form.get('name'), '1234', config.SECRET_KEY))
                elif action == 'delete':
                    cursor.execute("DELETE FROM instructor WHERE ID=%s", (request.form.get('id'),))
                    cursor.execute("DELETE FROM users WHERE userID=%s", (request.form.get('id'),))

            # --- STUDENT CRUD ---
            elif configuration == 3:
                if action == 'add':
                    uid = request.form.get('id')
                    cursor.execute("INSERT INTO student (ID, name, tot_credits) VALUES (%s, %s, 0)", (uid, request.form.get('name')))
                    cursor.execute("INSERT INTO users (userID, username, password, permission_level) VALUES (%s, %s, AES_ENCRYPT(%s, UNHEX(%s)), 0)",
                                   (uid, request.form.get('name'), '1234', config.SECRET_KEY))
                elif action == 'delete':
                    cursor.execute("DELETE FROM student WHERE ID=%s", (request.form.get('id'),))
                    cursor.execute("DELETE FROM users WHERE userID=%s", (request.form.get('id'),))

            # --- DEPT CRUD ---
            elif configuration == 4:
                if action == 'add':
                    cursor.execute("INSERT INTO department (dept_name, building, budget) VALUES (%s, %s, %s)", 
                                   (request.form.get('name'), request.form.get('building'), request.form.get('budget')))
                elif action == 'delete':
                    cursor.execute("DELETE FROM department WHERE dept_name=%s", (request.form.get('name'),))
            
            # --- SELF UPDATE ---
            if action == 'updateSelf':
                cursor.execute("UPDATE users SET username=%s WHERE userID=%s", (request.form.get('username'), session.get('ID')))
                session['username'] = request.form.get('username')

            db.commit()
            flash('Operation Successful', 'success')
        except Exception as e:
            flash(f'Error: {e}', 'danger')

    refresh_admin_data(configuration)
    cursor.close()
    return render_template('adminDash.html', configuration=configuration, data=session.get('adminData'))

# -------------------------------------------------------------------------
# Additional Helper Functions
# -------------------------------------------------------------------------

def getRandomID(table):
    cursor = db.cursor()
    val = 10000
    sql = "SELECT name FROM %s WHERE ID = %%s" % table # Safe format injection for table name
    cursor.execute(sql, (val,))
    data = cursor.fetchall()

    while data:
        val += 1
        cursor.execute(sql, (val,))
        data = cursor.fetchall()
    
    cursor.close()
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