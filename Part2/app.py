from flask import Flask, flash, redirect, render_template, request, jsonify, url_for, session
import config
import pymysql

# NOTE THIS DOES NOT CONTAIN THE REQUIRED ENVIRONMENT TO RUN
# INSTALL FLASK AND PYMYSQL AS REQUIRED BY PROF...

db = config.db1
app = Flask(__name__)
app.secret_key = config.SECRET_KEY

user = "", 

#Zone to add more


@app.route('/')
def returnHome():
    return render_template('index.html', user=session.get('username'))

@app.route('/login', methods = ['GET', 'POST'])
def loginPage():
    global user
    
    if request.method=='POST':
        if request.form.get('action') == "LOGIN":
            username = request.form.get('loginUser')
            password = request.form.get('loginPass')

            if not username or not password:
                flash('Invalid Credentials', 'danger')
                return redirect(url_for('loginPage'))

            sql = "SELECT username, password, permission_level FROM users where username=%s AND AES_DECRYPT(password, %s) = %s"
            cursor.execute(sql, (username, config.SECRET_KEY, password))
            tempUser = cursor.fetchall()

            if not tempUser:
                flash('Login not Found', 'danger')
                return redirect(url_for('loginPage'))
            
            session['username'] = tempUser[0][0]
            session['permission'] = tempUser[0][2]

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
            
            sql = "INSERT INTO users(username, password, permission_level, userID) VALUES (%s, AES_ENCRYPT(%s, %s), %s, %s)"
            cursor.execute(sql, (username, password, config.SECRET_KEY, permission, userID,))

            sql = f"INSERT INTO {table}(ID, name, tot_credits) VALUES ({userID}, {username}, 0)"
            cursor.execute(sql)

            db.commit()

            flash('User successfully created!', 'success')

    return render_template('login.html', user=user)

@app.route('/logout')
def logout():
    session.pop('username', None)
    session.pop('permission', None)
    flash('You have been logged out', 'info')
    return redirect(url_for('returnHome'))

@app.route('/dashboard')
def goToDash():
    if session.get('permission') == 2:
        return render_template('adminDash.html')
    elif session.get('permission') == 1:
        return render_template('instructorDash.html')
    else:
        return render_template('studentDash.html')



def getRandomID(table):
    val = 10000
    sql = f"SELECT name FROM {table} WHERE ID = %s"
    cursor.execute(sql, (val,))
    data = cursor.fetchall()

    while data:
        val += 1
        cursor.execute(sql, (val,))
        data = cursor.fetchall()
        
    return val

if __name__ == '__main__':
    cursor=db.cursor()
    app.run()