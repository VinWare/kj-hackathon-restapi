from flask import jsonify, make_response, g
from flask_httpauth import HTTPBasicAuth
from app import app
from .db_setup import mysql
from werkzeug.security import generate_password_hash, check_password_hash
from .helper import verify_token

auth = HTTPBasicAuth()

@auth.verify_password
def verify_password(username_token, password):
        user_id = verify_token(username_token)
        if not user_id:
                cur = mysql.connection.cursor()
                cur.execute("SELECT user_id, password_hash FROM user WHERE user_name = %s", (username_token,))
                user = cur.fetchone()
                if not user or not check_password_hash(user['password_hash'],password):
                        return False
                user_id = user['user_id']
        app.config['CURR_USER_ID'] = user_id
        return True

@auth.error_handler
def unauthorized():
    return make_response(jsonify({'error': 'Unauthorized access'}), 401)
