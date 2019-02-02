from app import app
from flask import jsonify, make_response, request, abort
from .auth_setup import auth
from .db_setup import mysql
from .helper import get_public_types, generate_token, make_public

@app.route('/')
@app.route('/index')
def index():
    return(jsonify({'content': 'Welcome to the home page of the crowdfunding rest api'}))

# GET routes
@app.route('/crowdfunding/api/v1.0.0/login', methods=['GET'])
@auth.login_required
def login():
    token = generate_token()
    return jsonify({'token': token.decode('ascii')})

@app.route('/crowdfunding/api/v1.0.0/students', methods=['GET'])
@auth.login_required
def students():
    cur = mysql.connection.cursor()
    cur.execute("SELECT user_id, user_name, full_name, college_name, year, branch FROM user NATURAL JOIN student")
    all_students = cur.fetchall()
    return(jsonify({'students': [make_public(student) for student in all_students]}))

@app.route('/crowdfunding/api/v1.0.0/students/<int:student_id>', methods=['GET'])
@auth.login_required
def student(student_id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT user_id, user_name, full_name, college_name, year, branch FROM user NATURAL JOIN student WHERE user_id=%s", (student_id,))
    student = cur.fetchone()
    return(jsonify({'student': make_public(student)}))

@app.route('/crowdfunding/api/v1.0.0/projects', methods=['GET'])
@auth.login_required
def projects():
    cur = mysql.connection.cursor()
    cur.execute("SELECT full_name, project_id, project_name, category, phase, cost, start_date, complete_date, project_type FROM user NATURAL JOIN student NATURAL JOIN project")
    all_projects = cur.fetchall()
    return(jsonify({'projects': [make_public(project) for project in all_projects]}))

@app.route('/crowdfunding/api/v1.0.0/projects/<int:project_id>', methods=['GET'])
@auth.login_required
def project(project_id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT full_name, project_id, project_name, category, phase, cost, start_date, complete_date, project_type FROM user NATURAL JOIN student NATURAL JOIN project WHERE project_id=%s", (project_id,))
    project = cur.fetchone()
    return(jsonify({'project': make_public(project)}))

@app.route('/crowdfunding/api/v1.0.0/sponsors', methods=['GET'])
@auth.login_required
def sponsors():
    cur = mysql.connection.cursor()
    cur.execute("SELECT user_id, user_name, full_name, company FROM user NATURAL JOIN sponsor")
    all_sponsors = cur.fetchall()
    return(jsonify({'sponsors': [make_public(sponsor) for sponsor in all_sponsors]}))

@app.route('/crowdfunding/api/v1.0.0/sponsors/<int:sponsor_id>', methods=['GET'])
@auth.login_required
def sponsor(sponsor_id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT user_id, user_name, full_name, company FROM user NATURAL JOIN sponsor WHERE user_id=%s", (sponsor_id,))
    sponsor = cur.fetchone()
    return(jsonify({'sponsor': make_public(sponsor)}))

# POST requests
@app.route('/crowdfunding/api/v1.0.0/sign-up', methods=['POST'])
def sign_up():
    if not request.json:
        abort(400)
    if not 'username' in request.json or not 'password' in request.json or not 'full-name' in request.json or not 'blockchain-address' in request.json:
        abort(400)
    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO user(username, password_hash, full_name, blockchain) VALUES(%s, %s, %s, %s)', (request.json['username'], request.json['password'], request.json['full-name'], request.json['blockchain-address']))
    mysql.connection.commit()

@app.route('/crowdfunding/ap/v1.0.0/project', methods=['POST'])
def create_project():
    if not request.json:
        abort(400)
    if not 'user_id' in request.json or not 'project_name' in request.json or not 'category' in request.json or not 'phase' in request.json or not 'cost' in request.json or not 'start_date' in request.json or not 'project_type' in request.json:
        abort(400)
    rj = request.json
    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO project(user_id, project_name, category, phase, cost, start_date, project_type) VALUES(%s, %s, %s, %s, %s, %s, %s)', (rj['user_id'], rj['project_name'], rj['category'], rj['phase'], rj['cost'], rj['start_date'], rj['project_type']))
    mysql.connect.commit()

@app.route('/crowdfunding/ap/v1.0.0/student', methods=['POST'])
def create_student():
    if not request.json:
        abort(400)
    if not 'user_id' in request.json or not 'college' in request.json or not 'year' in request.json or not 'branch' in request.json:
        abort(400)
    rj = request.json
    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO student(user_id, college, year, branch) VALUES(%s, %s, %s, %s)', (rj['user_id'], rj['college'], rj['year'], rj['branch']))
    mysql.connect.commit()

@app.route('/crowdfunding/ap/v1.0.0/sponsor', methods=['POST'])
def create_sponsor():
    if not request.json:
        abort(400)
    if not 'user_id' in request.json or not 'company' in request.json:
        abort(400)
    rj = request.json
    cur = mysql.connection.cursor()
    cur.execute('INSERT INTO sponsor(user_id,company) VALUES(%s, %s)', (rj['user_id'], rj['company']))
    mysql.connect.commit()

# Error handlers
@app.errorhandler(404)
def not_found_error(error):
    return make_response(jsonify({'error': 'Not Found'}), 404)