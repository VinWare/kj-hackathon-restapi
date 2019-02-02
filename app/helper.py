# Helper functions not related to flask
from itsdangerous import (TimedJSONWebSignatureSerializer as Serializer, BadSignature, SignatureExpired)
from app import app
from .db_setup import mysql
from flask import g, url_for
from werkzeug.security import generate_password_hash

def get_public_types():
    return ['Product']

def generate_token():
    serializer = Serializer(app.config['SECRET_KEY'], expires_in=app.config['EXPIRATION'])
    return serializer.dumps({'id': app.config['user_id']})

def verify_token(token):
    serializer = Serializer(app.config['SECRET_KEY'])
    try:
        data = serializer.loads(token)
    except SignatureExpired:
        return None
    except BadSignature:
        return None
    return data['id']

def make_public(student):
    new_student = {}
    for info in student:
        if info == 'user_id':
            new_student['url'] = url_for('student', student_id=student['id'], _external=True)
        else:
            new_student[info] = student[info]
    return new_student

def pass_hash(password):
    return generate_password_hash(password)