import json

with open('private/config.json') as file:
    config = json.load(file)

class Config:
    MYSQL_HOST = config['db']['host']
    MYSQL_USER = config['db']['user']
    MYSQL_PASSWORD = config['db']['password']
    MYSQL_DB = config['db']['dbname']
    MYSQL_CURSORCLASS = config['db']['cursorclass']
    SECRET_KEY = config['security']['secretkey']
    EXPIRATION = config['security']['expiration']