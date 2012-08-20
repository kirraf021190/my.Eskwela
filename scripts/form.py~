from dosql import *
from mod_python import Session
import hashlib
import uuid
import cgi

def login(req, username, pwd):
	a = doSql()
	#Query to retrieve SALT from DATABASE
	salt = a.execqry("select getsalt('"+username+"')", False)[0][0]
	x = str(salt)
	hashPass = encryptPass(x, pwd)
	hashPass_ = cgi.escape(hashPass)
    	f = a.execqry("select login('"+hashPass_+"', '"+username+"')", False)[0][0]
	session = Session.Session(req)
	if (f == 'TRUE'):
		return "<html><body onload='location.href=\"../../html/about/index.html\"'></body></html>"
	else:
		session['invalid'] = salt
		session.save()
		return "<html><body onload='location.href=\"../../scripts/login\"'></body></html>"

def section(req, sec, sy, subj, code):
	session = Session.Session(req)
	if(checkSession(req, session)):
		session['class'] = sec
		session['sy'] = sy
		session['subj'] = subj
		session['sCode'] = code
		
		session.save()
		return "<html><body onload='location.href=\"../../html/grades.html\"'></body></html>"
	else:
		return "<html><body onload='location.href=\"../login\"'></body></html>"


def checkSession(req, session):
	
	if('id' in session):
		return True
	else:
		session['invalid'] = "You Have to Log In to Continue"
		session.save()
		return False

def checkSessionJs(req):
	session = Session.Session(req)
	if('id' in session):
		return True
	else:
		session['invalid'] = "You Have to Log In to Continue"
		session.save()
		return False

def logout(req):
	session = Session.Session(req)
	session['invalid'] = "You Have Been Logged Out."
	session.save()
	return "<html><body onload='location.href=\"../login\"'></body></html>"

def encryptPass(salt, pwd):
	hashPass = hashlib.sha512(pwd + salt).hexdigest()
	return hashPass

def generateSalt():
	salt = uuid.uuid4().hex
	return salt	
