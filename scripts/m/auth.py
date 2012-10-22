from myEskwela import *
import psycopg2, string, uuid, hashlib

def index(req):
    string = ''

    #Connect to Database
    #database = pg.connect('myEskwela', 'localhost', 5432, None, None, 'postgres', 'password')
    #database = Database("GUEST")

    form = req.form
    username = form['username']
    password = form['password']
    
    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor(); 

    #authHandler = Auth(username, password)
    #isAuthenticated = False;

    mySalt = get_my_salt(curr, username); ePassword = encryptPass(mySalt, password)

    arg1 = "SELECT login(%s, %s)"; arg2 = (username, ePassword);
    curr.execute(arg1, arg2); data = curr.fetchall(); isAuth = data[0][0]

    if (isAuth == "TRUE"):
        sessionID = generate_salt()
        userID = get_id_number_from_username(curr, username)
        userRole = get_user_role_from_username(curr, username)

        string = '{"status":"valid", "sessionID":"'+sessionID+'", "username":"'+username+'", "userID":"'+userID+'", "userRole":"'+userRole+'"}'
    else:
        string = '{"status":"invalid"}'
  
    #if (authHandler.auth(database)):
    #     sessionID = authHandler.get_session_ID(database)
    #     userID    = authHandler.get_id_number_from_username(database)
    #     userRole  = authHandler.get_user_role_from_username(database)
         
    #     string = '{"status":"valid", "sessionID":"'+sessionID+'", "username":"'+username+'", "userID":"'+userID+'", "userRole":"'+userRole+'"}'
    #else:
    #     string = '{"status":"invalid"}'
    
    


    #Close DB
    #database.close()
    conn.close(); curr.close()
    return string

def encryptPass(salt, pwd):
    hashPass = hashlib.sha512(pwd + salt).hexdigest()
    return hashPass

def generate_salt():
    salt = uuid.uuid4().hex
    return salt

def get_my_salt(c, u):
    arg1 = "SELECT getsalt(%s)"; arg2 = (u,)
    c.execute(arg1, arg2); data = c.fetchall()
    
    return data[0][0]

def get_id_number_from_username(c, u):
    arg1 = "SELECT account_role_id(%s)"; arg2 = (u,)
    c.execute(arg1, arg2); data = c.fetchall()

    return data[0][0]

def get_user_role_from_username(c, u):
    arg1 = "SELECT account_role(%s)"; arg2 = (u,)
    c.execute(arg1, arg2); data = c.fetchall()

    return data[0][0]
