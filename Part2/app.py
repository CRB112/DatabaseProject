from flask import Flask, render_template, request, jsonify
import config
import pymysql

# NOTE THIS DOES NOT CONTAIN THE REQUIRED ENVIRONMENT TO RUN
# INSTALL FLASK AND PYMYSQL AS REQUIRED BY PROF...

db = config.db1
app = Flask(__name__)

user = "", "", -1


#Zone to add more


@app.route('/')
def returnHome():
    if user == ("", "", -1):
        return render_template('login.html')
    return render_template('index.html', user=user)

if __name__ == '__main__':
    cursor=db.cursor()
    app.run()