#!flask/bin/python
import sys
from app import app

if __name__ == '__main__':
    debug = False
    if(len(sys.argv) == 2 and sys.argv[1] == 'debug'):
        debug = True
    app.run(debug=debug)
