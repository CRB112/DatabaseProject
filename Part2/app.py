from flask import Flask, flash, redirect, render_template, request, jsonify, url_for, session
import config
import pymysql

# NOTE THIS DOES NOT CONTAIN THE REQUIRED ENVIRONMENT TO RUN
# INSTALL FLASK AND PYMYSQL AS REQUIRED BY PROF...

db = config.db1
app = Flask(__name__)
app.secret_key = config.SECRET_KEY

#Zone to add more


@app.route('/')
def returnHome():
    return render_template('index.html', user=session.get('username'))

@app.route('/login', methods = ['GET', 'POST'])
def loginPage():
    global user
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

    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('username', None)
    session.pop('permission', None)
    flash('You have been logged out', 'info')
    return redirect(url_for('returnHome'))

@app.route('/dashboard')
def goToDash():
    if session.get('permission') == 2:
        return render_template('adminDash.html', user=session.get('username'))
    elif session.get('permission') == 1:
        if session.get('salary') == 0:
            flash('Please input your salary', 'warning')
        if session.get('dept_name') == None:
            flash('Please select your department', 'warning')
        return render_template('instructorDash.html', user=session.get('username'), salary=session.get('salary'), dept_name=session.get('dept_name'))
    else:
        return render_template('studentDash.html', user=session.get('username'), tot_credits=session.get('tot_credits'), advisor_id=session.get('advisor_id'))



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

if __name__ == '__main__':
    cursor=db.cursor()
    app.run()