from dosql import *
import cgi
from mod_python import Session
import time
import os
import form

def getClasses(req):
	session = Session.Session(req)
	a = doSql()
	t = a.execqry("select current_term()", False)[0][0]
	f = a.execqry("select faculty_load_information('"+str(session['id'])+"','"+str(t)+"')", False)
	p = ''
	for x in xrange(len(f)):
		p = p + f[x][0] + '@'
	return p

def getTeacherInfo(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select picture from faculty where fac_id = '"+session['id']+"' limit 1", False)[0][0]
	#session.delete() #end session
        return session['name']+"$"+session['id']+"$"+session['dept']+"$"+session['college']+"$"+f

def getInfo(req):
	session = Session.Session(req)
	a = doSql()
	if(session['usertype'] == 'FACULTY'):
		f = a.execqry("select faculty_information('"+str(session['id'])+"')", False)[0][0]
		return f
	elif(session['usertype'] == 'PARENT'):
		f = a.execqry("select parent_information('"+str(session['id'])+"')", False)[0][0]
		return f
	else:		
		f = a.execqry("select student_information('"+str(session['id'])+"')", False)[0][0]
		return f
	
def changePassword(req, currentPassword, confirmPassword, newPassword):
	session = Session.Session(req)
	if currentPassword == confirmPassword:
		a = doSql()
		f = a.execqry("select username from user_account where acct_id = '"+session['id']+"'", False)
		b = a.execqry("update user_account set password = '"+newPassword+"' where username = '"+f+"'", true)
		return True
	else:
		return False

def addAttendance(req, idnum_):
	session = Session.Session(req)
	b = cgi.escape(idnum_)
	x = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
	e = doSql()
	t = e.execqry("SELECT get_ongoing_session('"+session['scode']+"')", False)[0][0]
	f = e.execqry("SELECT add_attendance('"+str(t)+"','"+b+"','"+x+"')", True)[0][0]
	return f
		
def changepassword(req, oldpass, newpass):
	session = Session.Session(req)
	a = doSql()
	x = a.execqry("select getsalt('"+session['id']+"')", False)[0][0]
	oldsalt = str(x)	
	newsalt = form.generateSalt()
	oldhash = form.encryptPass(oldsalt, oldpass)
	newhash = form.encryptPass(newsalt, newpass)
	f = a.execqry("SELECT change_password('"+session['id']+"','"+oldhash+"','"+newhash+"','"+newsalt+"')", True)[0][0]
	if (f == 'true'):
	    return 'success'
	else:
		return 'invalid password'

def resetpassword(req, username):
	session = Session.Session(req)
	a = doSql()
	randPassword = os.urandom(5)
	newsalt = form.generateSalt()
	newhash = form.encryptPass(newsalt, randPassword)
	f = a.execqry("SELECT resetpass('"+username+"','"+newsalt+"','"+newhash+"')", True)[0][0]
	if (f == 'true'):
		i = a.execqry("select getid('"+username+"')", False)[0][0]
		e = a.execqry("select getemail('"+str(i)+"')", False)[0][0]
		useremail = str(e)
		form.sendemail(from_addr = 'myeskwela.noreply@gmail.com', to_addr_list = [useremail], cc_addr_list = [useremail], subject = 'Password Reset', message = 'Your new password is ' + randPassword, login = 'myeskwela.noreply@gmail.com', password = 'myeskwela')
		return 'sucess'
	else:
		return 'user does not exist'

def registerUser(req,uname, pwd, email, fname, mname, lname):
	a = doSql()
	b = cgi.escape(uname)
	c = cgi.escape(email)
	d = cgi.escape(fname)
	e = cgi.escape(mname)
	g = cgi.escape(lname)
	salt = form.generateSalt()
	hashPass = form.encryptPass(salt, pwd)
	#stored proc for this. update user accounts with new parent account.
	f = a.execqry("SELECT addparent('"+b+"','"+salt+"','"+hashPass+"','"+d+"','"+e+"','"+g+"','"+c+"')", True)[0][0]
	return f

def getGradeSystem(req):
	session = Session.Session(req)
	a = doSql()
	p = ''
	f = a.execqry("SELECT get_grading_system_information('"+session['scode']+"')", False)
	for x in xrange(len(f)):
		p = p + f[x][0] + '@'
	return p
	
def getAttendanceBySubject(req):
	session = Session.Session(req)
	a = doSql()
	t = a.execqry("SELECT get_ongoing_session('"+session['scode']+"')", False)[0][0]
	session['session_id'] = str(t)
	session.save()
	f = a.execqry("SELECT get_section_attendance('"+session['session_id']+"')", False) 
	p = ''
	if (f[0][0] == 'None'):
		return ''
	else:
		for x in xrange(len(f)):
			p = p + f[x][0] + '@'
		return p
	
def getCurrentClass(req):
	session = Session.Session(req)
	return session['class']

def setGradeSystem(req,name_,weight_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(name_)
	c = cgi.escape(weight_)
	f = a.execqry("SELECT add_grading_system('"+b+"','"+c+"','"+session['scode']+"')", True) [0][0]
	return f
	
def editCatWeight(req,catid_,weight_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(catid_)
	c = cgi.escape(weight_)
	f = a.execqry("SELECT edit_grading_system_weight('"+b+"','"+c+"')", True) [0][0]
	return f

def deleteCategory(req,catid_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(catid_)
	f = a.execqry("SELECT delete_grade_system_entry('"+b+"', '"+session['scode']+"')", True) [0][0]
	return f

def confirmAttend(req,idnum_,time):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(idnum_)
	c = cgi.escape(time)
	f = a.execqry("SELECT confirmattendance('"+b+"', '"+session['scode']+"', '"+c+"')", True) [0][0]
	return f
	
def getGradeItems(req,catid_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(catid_)
	f = a.execqry("SELECT get_grade_item_information('"+b+"')", False) 
	p = ''
	if (f[0][0] == 'None'):
		return ''
	else:
		for x in xrange(len(f)):
			p = p + f[x][0] + '@'
		return p

def addGradeItem(req,name_,maxscore_,catid_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(name_)
	c = cgi.escape(maxscore_)
	d = cgi.escape(catid_)
	x = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
	f = a.execqry("SELECT add_grade_item('"+b+"','"+d+"','"+c+"','"+x+"')", True) [0][0]
	return f
	
def editMaxScore(req,gradeitemid_,maxscore_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(gradeitemid_)
	c = cgi.escape(maxscore_)
	f = a.execqry("SELECT edit_gradeitem_totalscore	('"+b+"','"+c+"')", True) [0][0]
	return f
	
def deleteGradeItem(req,name_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(name_)
	f = a.execqry("SELECT delete_grade_item('"+b+"')", True) [0][0]
	return f
	
def deleteStudentGrade(req,gradeid_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(gradeid_)
	f = a.execqry("SELECT delete_grade_item_entry('"+b+"')", True) [0][0]
	return f
	
def editStudentGradeScore(req,gradeitemid_,newscore_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(gradeitemid_)
	c = cgi.escape(newscore_)
	f = a.execqry("SELECT edit_item_entry_score('"+b+"','"+c+"')", True) [0][0]
	return f
	
def getStudentGrades(req,gradeitemid_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(gradeitemid_)
	f = a.execqry("SELECT get_grade_item_entry_information('"+b+"')", False)
	p = ''
	if (f[0][0] == 'None'):
		return ''
	else:
		for x in xrange(len(f)):
			p = p + f[x][0] + '@'
		return p
	
def addStudentGrade(req,studentid_,score_,gradeitemid_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(studentid_)
	c = cgi.escape(score_)
	d = cgi.escape(gradeitemid_)
	#f = a.execqry("SELECT addstudentgrade('"+b+"','"+c+"','"+d+"','"+session['scode']+"')", True) [0][0]
	f = a.execqry("SELECT add_grade_item_entry('"+d+"','"+c+"','"+b+"')", True) [0][0]
	return f
	
def studentIdAutoComp(req):
	session = Session.Session(req)
	a = doSql()
	#f = a.execqry("SELECT addstudentgrade('"+b+"','"+c+"','"+d+"','"+session['scode']+"')", True) [0][0]
	#return [('2010-7171',), ('2008-1234',)]
	#return ['a','b','c']
	f = a.execqry("SELECT enrolled('"+session['scode']+"')", False)
	p = ''
	#z = [('2010-7171',), ('2009-1625',)]
	for x in xrange(len(f)): 
		p = p + f[x][0] + '@'
	return p
	
def startClassSession(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("SELECT add_class_session('"+session['scode']+"')", True) [0][0]
	return f
	
def getCurrentSession(req):
	session = Session.Session(req)
	return session['session_id']
	
def dismissClassSession(req):
	session = Session.Session(req)
	a = doSql()
	t1 = a.execqry("SELECT get_ongoing_session('"+session['scode']+"')", False)[0][0]
	f = a.execqry("SELECT dismiss_class_session('"+str(t1)+"')", True) [0][0]
	t = a.execqry("SELECT get_ongoing_session('"+session['scode']+"')", False)[0][0]
	session['session_id'] = str(t)
	session.save()
	return t
	
def getStudentStats(req,idnum_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(idnum_)
	f = a.execqry("select student_information('"+b+"')", False)[0][0]
	return f
	
def getEnrolledNames(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("SELECT enrolled_student_names('"+session['scode']+"')", False)
	p = ''
	if (f[0][0] == 'None'):
		return ''
	else:
		for x in xrange(len(f)):
			p = p + f[x][0] + '@'
		return p
		
def getSessionAbsences(req,idnum_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(idnum_)
	f = a.execqry("select student_sessions_absented_information('"+b+"','"+session['scode']+"')", False)
	p = ''
	if (f[0][0] == 'None'):
		return ''
	else:
		for x in xrange(len(f)):
			p = p + f[x][0] + '@'
		return p
		
def countAbsences(req,idnum_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(idnum_)
	f = a.execqry("select student_absence_count('"+b+"','"+session['scode']+"')", False)[0][0]
	g = a.execqry("select student_attendance_count('"+b+"','"+session['scode']+"')", False)[0][0]
	s = int(f) + int(g)
	return str(g) + '/' + str(s)

def getChildrenNames(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("SELECT get_children_names('"+session['id']+"')", False)
	p = ''
	if (f[0][0] == 'None'):
		return ''
	else:
		for x in xrange(len(f)):
			p = p + f[x][0] + '@'
		return p

def populateClassRecord(req,catid_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(catid_)
	f = a.execqry("SELECT populateclassrecord('"+b+"')", False)
	p = ''
	if (f[0][0] == 'None'):
		return ''
	else:
		for x in xrange(len(f)):
			p = p + f[x][0] + '@'
		return p
	
def getStandingGrade(req,idnum_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(idnum_)
	f = a.execqry("select standing_grade('"+b+"','"+session['scode']+"')", False)[0][0]
	return f
	
def parentViewer(req,idnum_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(idnum_)
	f = a.execqry("select parent_viewer('"+b+"')", False)
	p = ''
	if (f[0][0] == 'None'):
		return ''
	else:
		for x in xrange(len(f)):
			p = p + f[x][0] + '@'
		return p

def studViewer(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select parent_viewer('"+str(session['id'])+"')", False)
	p = ''
	if (f[0][0] == 'None'):
		return ''
	else:
		for x in xrange(len(f)):
			p = p + f[x][0] + '@'
		return p
		
	
