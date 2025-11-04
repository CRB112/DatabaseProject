from flask import Flask, flash, redirect, render_template, request, jsonify, url_for, session
import config
import pymysql

# NOTE THIS DOES NOT CONTAIN THE REQUIRED ENVIRONMENT TO RUN
# INSTALL FLASK AND PYMYSQL AS REQUIRED BY PROF...

db = config.db1
app = Flask(__name__)
app.secret_key = config.SECRET_KEY

user = ("", -1)


#Zone to add more


@app.route('/')
def returnHome():
    return render_template('index.html', user=session.get('username'))

@app.route('/login', methods = ['GET', 'POST'])
def loginPage():
    global user
    
    if request.method=='POST':
        username = request.form.get('loginUser')
        password = request.form.get('loginPass')
        
        print(username, password)

        if not username or not password:
            flash('Invalid Credentials', 'danger')
            return redirect(url_for('loginPage'))

        sql = "SELECT username, permission_level FROM users where username=%s AND password=%s"
        cursor.execute(sql, (username, password,))
        tempUser = cursor.fetchall()

        if not tempUser:
            flash('Login not Found', 'danger')
            return redirect(url_for('loginPage'))
        
        session['username'] = tempUser[0][0]
        session['password'] = tempUser[0][1]

        return redirect(url_for('returnHome'))

    return render_template('login.html', user=user)

@app.route('/logout')
def logout():
    session.pop('username', None)
    session.pop('password', None)
    flash('You have been logged out', 'info')
    return redirect(url_for('returnHome'))


if __name__ == '__main__':
    cursor=db.cursor()
    app.run()