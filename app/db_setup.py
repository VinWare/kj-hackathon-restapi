from app import app
from flask_mysqldb import MySQL
import json

with open('private/config.json') as file:
    config = json.load(file)
app.config['MYSQL_HOST'] = config['db']['host']
app.config['MYSQL_USER'] = config['db']['user']
app.config['MYSQL_PASSWORD'] = config['db']['password']
app.config['MYSQL_DB'] = config['db']['dbname']

mysql = MySQL(app)