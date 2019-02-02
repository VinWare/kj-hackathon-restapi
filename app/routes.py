from app import app
from flask import jsonify
from .auth_setup import auth

@app.route('/')
@app.route('/index')
@auth.login_required
def index():
    return jsonify({'body': 'Hello, World!'})
