import pg, string, os

class Auth:

    def __init__(self, username, password):
        self.authenticate = 0
        self.username = username
        self.password = password

    #Auth Checker...
    def auth(self, db):
        q0 = "SELECT login('"+self.username+"', '"+self.password+"')";
        query = db.query(q0); result = query.dictresult();
        
        if (result[0]['login'] == "TRUE"):
            return True
        else:
            return False

    #Getting User Role
    def get_user_role_from_username(self, db):
        q0 = "SELECT account_role('"+self.username+"')"
        query = db.query(q0); result = query.dictresult();

        return result[0]['account_role']

    #Getting ID Number...
    def get_id_number_from_username(self, db):
        q0 = "SELECT account_role_id('"+self.username+"')"
        query = db.query(q0); result = query.dictresult();

        return result[0]['account_role_id']

    #Generate SessionID:
    def get_session_ID(self, db):
        return "TEST_SESSION_ID1"

    #Generating JSON String format...
    def generate_json(self):
        string = ""
        
        return string


class Database:

    def __init__(self):
        self.db = pg.connect('myEskwela', 'localhost', 5432, None, None, 'postgres', 'password')

    def close(self):
        db = self.db
        db.close()


