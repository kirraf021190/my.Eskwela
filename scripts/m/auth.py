
def index(req):
    string = ''
    
    if (authenticate(req) == "true"):
         string = '{"status":"valid", "sessionID":"'+generate_session_id()+'", "userID":"2009-0661", "userRole":"'+get_user_role(req)+'"}'
    else:
         string = '{"status":"invalid"}'

    return string


def authenticate(req):
    form = req.form #extracts the form data f
    username = form['username'] #gets the POST/GET variable "username"
    password = form['password'] #gets the POST/GET variable "password"

    #Faking the Login action... TODO: use the PyGreSQL
    if (username == "kiethmark.bandiola" and password == "kmbandiola"):
        return "true"
    else:
        return "false"

def generate_session_id():
    return "ppppp"

def get_user_id(req):
    form = req.form
    username = form['username']

    return "P"

def get_user_role(req):
    form = req.form
    username = form['username']

    if (username == "kiethmark.bandiola"):
        return "STUDENT"
    elif (username == "edwin.bandiola"):
        return "PARENT"
    else:
        return "null"
