from dosql import *
from mod_python import Session
import hashlib
import uuid
import cgi
import smtplib

def login(req, username, pwd):
	a = doSql()
	session = Session.Session(req)
	#Query to retrieve SALT from DATABASE
	salt = a.execqry("select getsalt('"+username+"')", False)[0][0]
	x = str(salt)
	if (x == 'false'):
		session['invalid'] = 'Invalid username or password'
		session.save()
		return "<html><body onload='location.href=\"../../scripts/login\"'></body></html>"
		
	hashPass = encryptPass(x, pwd)
	hashPass_ = cgi.escape(hashPass)
  	f = a.execqry("select login('"+username+"', '"+hashPass_+"')", False)[0][0]
	if (f == 'TRUE'):
		session['id'] = a.execqry("select account_role_id('"+username+"')", False)[0][0]
		session['usertype'] = a.execqry("select account_role('"+username+"')", False)[0][0]
		session.save()
		if (session['usertype'] == 'STUDENT'):
			return "<html><body onload='location.href=\"../../html/student_index.html\"'></body></html>"
		elif (session['usertype'] == 'FACULTY'):
			return "<html><body onload='location.href=\"../../html/prof_index.html\"'></body></html>"
		else:
			return "<html><body onload='location.href=\"../../html/parent_index.html\"'></body></html>"

	else:
		session['invalid'] = 'Invalid username or password'
		session.save()
		return "<html><body onload='location.href=\"../../scripts/login\"'></body></html>"

def section(req, sec, scode):
	session = Session.Session(req)
	if(checkSession(req, session)):
		session['class'] = sec
		session['scode'] = scode
		session.save()
		return "<html><body onload='location.href=\"../../html/view.html\"'></body></html>"
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
	
def sendemail(from_addr, to_addr_list, cc_addr_list,
              subject, message,
              login, password,
              smtpserver='smtp.gmail.com:587'):
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
