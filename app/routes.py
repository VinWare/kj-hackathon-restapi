from app import app
from flask import jsonify
from .auth_setup import auth
from .db_setup import mysql

@app.route('/')
@app.route('/index')
@auth.login_required
def index():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM user')
    return jsonify(cur.fetchall())
