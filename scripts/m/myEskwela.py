import pg, string, os
import smtplib

class Auth:

    def __init__(self, username, password):
        self.authenticate = 0
        self.username = username
        self.password = password

    #Auth Checker...
    def auth(self, db):

		q1 = "SELECT getsalt('"+self.username +")"
        
        query2 = db.query(q1); salt = quesry2.dictresult()
		hash = encryptPass(salt, self.password)
		
		q0 = "SELECT login('"+self.username+"', '"+hash+"')" #edit login to accept hash instead of password
		query = db.query(q0); result = query.dictresult()
        
		if (result[0]['login'] == "TRUE"):
            return True
        else:
            return False
			
	def encryptPass(salt, pwd):
	hashPass = hashlib.sha512(pwd + salt).hexdigest()
	return hashPass
			
    #Getting User Role
    def get_user_role_from_username(self, db):
        q0 = "SELECT account_role('"+self.username+"')"
        query = db.query(q0); result = query.dictresult()

        return result[0]['account_role']

    #Getting ID Number...
    def get_id_number_from_username(self, db):
        q0 = "SELECT account_role_id('"+self.username+"')"
        query = db.query(q0); result = query.dictresult()

        return result[0]['account_role_id']

    #Generate SessionID:
    def get_session_ID(self, db):
        return "TEST_SESSION_ID1"

    #Generating JSON String format...
    def generate_json(self):
        string = ""
        
        return string

class Email:

	def __init__(self):
		print "foo"
	
	def sendemail(from_addr, to_addr_list, cc_addr_list, subject, message, login, password, smtpserver='smtp.gmail.com:587'):
		header  = 'From: %s\n' % from_addr
		header += 'To: %s\n' % ','.join(to_addr_list)
		header += 'Cc: %s\n' % ','.join(cc_addr_list)
		header += 'Subject: %s\n\n' % subject
		message = header + message
 
		server = smtplib.SMTP(smtpserver)
		server.starttls()
		server.login(login,password)
		problems = server.sendmail(from_addr, to_addr_list, message)
		server.quit()
		return problems		

class Database:

    def __init__(self):
        self.db = pg.connect('myEskwela', 'localhost', 5432, None, None, 'postgres', 'password')

    def close(self):
        db = self.db
        db.close()


