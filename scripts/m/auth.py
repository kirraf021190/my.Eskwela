from myEskwela import *

def index(req):
    string = ''

    #Connect to Database
    #db = pg.connect('myEskwela', 'localhost', 5432, None, None, 'postgres', 'password')
    database = Database()
    form = req.form
    username = form['username']
    password = form['password']

    authHandler = Auth(username, password)
    
    if (authHandler.auth(database.db)):
         sessionID = authHandler.get_session_ID(database.db)
         userID    = authHandler.get_id_number_from_username(database.db)
         userRole  = authHandler.get_user_role_from_username(database.db)
         
         string = '{"status":"valid", "sessionID":"'+sessionID+'", "userID":"'+userID+'", "userRole":"'+userRole+'"}'
    else:
         string = '{"status":"invalid"}'

    #Close DB
    database.db.close()
    return string
