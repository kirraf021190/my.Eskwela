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
	else:
		f = a.execqry("select getinfo('"+str(session['id'])+"','"+session['usertype']+"')", False)[0][0]
		return f		
	

def getSectionStudents(req):
	session = Session.Session(req) 
	a = doSql()
    	f = a.execqry("select getstudents('"+session['class']+"', '"+session['sy']+"', '"+session['subj']+"')", False)[0][0]
	return f

def getSubjName(req):

	session = Session.Session(req)
	a = doSql()
    	f = a.execqry("select getsubjname('"+session['sCode']+"')", False)[0][0]
	return f

def getCategories(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select getCategories('"+session['sCode']+"')", False)[0][0]
	return f

def getScale(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select getscale('"+session['sCode']+"') ", False)[0][0]
	return f

def updateMaxScale(req, maxscale1_, maxscale2_, ):
	session = Session.Session(req)
	oN = cgi.escape(maxscale1_)
	uN = cgi.escape(maxscale2_) 
	a = doSql()
	f = a.execqry("select updatemaxscale('"+session['sCode']+"', '"+oN+"', '"+uN+"')", True)
	return True

def updateMinScale(req, minscale1_, minscale2_, ):
	session = Session.Session(req)
	oN = cgi.escape(minscale1_)
	uN = cgi.escape(minscale2_) 
	a = doSql()
	f = a.execqry("select updateminscale('"+session['sCode']+"', '"+oN+"', '"+uN+"')", True)
	return True

#def updateScale(req, sOrig, sUpd, rhigh, rlow):
#	session = Session.Session(req)
#	sO = cgi.escape(sOrig)
#	sU = cgi.escape(sUpd) 
#	rH = cgi.escape(rhigh)
#	rL = cgi.escape(rlow) 
#	a = doSql()
#	f = a.execqry("select updatescale('"+session['sCode']+"', '"+sOrig"', '"+sUpd+"','"+rhigh"', '"+rlow+"') ", True)
#	return True

def addCategory(req, catName, weight, aggr):
	session = Session.Session(req)	
	b = cgi.escape(catName)
	c = cgi.escape(weight)
	d = cgi.escape(aggr)
	e = doSql()
	f = e.execqry("select addcategory('"+session['sCode']+"','"+b+"','"+c+"', '"+d+"')", True)
	return True

def remCategory(req, catName):
	session = Session.Session(req)
	b = cgi.escape(catName)
	e = doSql()
	f = e.execqry("select remcategory('"+session['sCode']+"','"+b+"')", True)
	return True

def updateCategory(req, name1_, name2_, weight, aggr):
	session = Session.Session(req)
	oN = cgi.escape(name1_)
	uN = cgi.escape(name2_) 
	oW = cgi.escape(weight) 
	oA = cgi.escape(aggr)
	a = doSql()
	f = a.execqry("select updatecategory('"+session['sCode']+"', '"+oN+"', '"+uN+"', '"+oW+"', '"+oA+"')", True)
	return True


def addGrpPerformance(req, description, maxscore, period, date):
	session = Session.Session(req)
	#k = cgi.escape(grp_perfID)
	#e = cgi.escape(grdcat)
	g = cgi.escape(description)
	h = cgi.escape(maxscore)
	i = cgi.escape(period)
	#l = cgi.escape(cat_id)
	j = cgi.escape(date)
	k = doSql()
	f = k.execqry("select addgrp_performance('"+session['sCode']+"', '"+g+"','"+h+"', '"+i+"', '"+j+"')", True)
	return True

def getGrpPerf(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select getgrp_performance('"+session['sCode']+"')", False)[0][0]
	return f

def remGrpPerf(req, description):
	session = Session.Session(req)
	b = cgi.escape(description)
	e = doSql()
	f = e.execqry("select remgrp_performance('"+session['sCode']+"','"+b+"')", True)
	return True

def getPerformance(req, grp_perf_id):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select getperformance('"+grp_perf_id+"')", False)[0][0]
	return f

def getHeaderReport(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select getheader('"+session['sCode']+"')", False)[0][0]
	return f 

def getCat(req):
	session = Session.Session(req)
	a = doSql()

	f = a.execqry("select getcat('"+session['sCode']+"')", False)[0][0]
	g = f.split('@')
	options = ''
	for details in g:
		details1 = details.split('$')
		options += '<option>' +details1[0]+ '</option>'

	return options

def getCat2(req):
	session = Session.Session(req)
	a = doSql()

	f = a.execqry("select getcat2('"+session['sCode']+"')", False)[0][0]
	g = f.split('@')
	options = ''
	for details in g:
		details1 = details.split('$')
		options += '<option>' +details1[0]+ '</option>'

	return options

def getStudPerf(req):

	session = Session.Session(req)
	a = doSql()
    	f = a.execqry("select getstudents('"+session['class']+"', '"+session['sy']+"', '"+session['subj']+"')", False)[0][0]
	return f


def getAttend(req, subjcode, idnum):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(subjcode)
	c = cgi.escape(idnum)
	f = a.execqry("select getattendance('"+b+"', '"+c+"') ", False)[0][0]
	return f

def addAttend(req, catName, weight, aggr):
	session = Session.Session(req)	
	b = cgi.escape(catName)
	c = cgi.escape(weight)
	d = cgi.escape(aggr)
	e = doSql()
	f = e.execqry("select addcategory('"+session['sCode']+"','"+b+"','"+c+"', '"+d+"')", True)
	return True

def updateGradeItem(req, grdcat1, grade1_, grade2_, maxscore, date, period):
	session = Session.Session(req)
	oC = cgi.escape(grdcat1)	
	oG = cgi.escape(grade1_)
	uG = cgi.escape(grade2_) 
	oM = cgi.escape(maxscore) 	
	oP = cgi.escape(period)
	oD = cgi.escape(date)
	a = doSql()
	f = a.execqry("select updategrp_performance('"+session['sCode']+"', '"+oC+"', '"+oG+"', '"+uG+"', '"+oM+"', '"+oP+"', '"+oD+"')", True)
	return True

def updatePerformance(req, perfID1, score1_, score2_, mult, grpPerfID, regID):
	session = Session.Session(req)
	oI = cgi.escape(perfID1)	
	oS = cgi.escape(score1_)
	uS = cgi.escape(score2_) 
	oM = cgi.escape(mult) 	
	oG = cgi.escape(grpPerfID)
	oR = cgi.escape(regID)
	a = doSql()
	f = a.execqry("select updateperformance('"+session['sCode']+"', '"+oI+"', '"+oS+"', '"+uS+"', '"+oM+"', '"+oG+"', '"+oR+"')", True)
	return True

def getScore(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select getstudents('"+session['class']+"', '"+session['sy']+"', '"+session['subj']+"')", False)[0][0]
	return f

def addScore(req, score, mult):
	session = Session.Session(req)	
	b = cgi.escape(score)
	c = cgi.escape(mult)
	e = doSql()
	f = e.execqry("select addscore('"+session['sCode']+"','"+b+"','"+c+"')", True)
	return True

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

#def linkUsers(req, user):
#	session = Session.Session(req)
#	user = cgi.escape(user)
#	a = doSql()
#	f = a.execqry("select requestlink('"+session['id']+"', '"+user+"', true)	
#   return f

def showSubjects(req, idnum):
	a = doSql()
	b = cgi.escape(idnum)
	f = a.execqry("SELECT * enrolledsubj where idnum = '"+b+"')")
	return f

def getGradeSubject(req, idnum, subj):
	a = doSql()
	b = cgi.escape(idnum)
	c = cgi.escape(subj)
	f = a.execqry("SELECT * grades where idnum = '"+b+"', subj = '"+c+'')
	return f

def getGradeSystem(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("SELECT getgradesystem('"+session['scode']+"')", False) [0][0]
	return f
	
def inputGrade(req, subject, testNum, score):
	a = doSql()
	b = cgi.escape(subject)
	c = cgi.escape(testNum)
	d = cgi.escape(score)
	f = a.execqry("SELECT addgrade('"+b+"','"+c+"','"+d+"','"+str(session['id'])+"')", True) [0][0]
	return f
	
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
	f = a.execqry("SELECT addgradecategory('"+b+"','"+c+"','"+session['scode']+"')", True) [0][0]
	return f
	
def editCatWeight(req,name_,weight_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(name_)
	c = cgi.escape(weight_)
	f = a.execqry("SELECT editcatweight('"+b+"','"+c+"','"+session['scode']+"')", True) [0][0]
	return f

def deleteCategory(req,name_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(name_)
	f = a.execqry("SELECT deletegradecategory('"+b+"', '"+session['scode']+"')", True) [0][0]
	return f

def confirmAttend(req,idnum_,time):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(idnum_)
	c = cgi.escape(time)
	f = a.execqry("SELECT confirmattendance('"+b+"', '"+session['scode']+"', '"+c+"')", True) [0][0]
	return f
	
def getGradeItems(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("SELECT getgradeitems('"+session['scode']+"')", False) [0][0]
	return f

def addGradeItem(req,name_,maxscore_,gradecat_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(name_)
	c = cgi.escape(maxscore_)
	d = cgi.escape(gradecat_)
	f = a.execqry("SELECT addgradeitem('"+b+"','"+c+"','"+d+"','"+session['scode']+"')", True) [0][0]
	return f
	
def editMaxScore(req,name_,maxscore_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(name_)
	c = cgi.escape(maxscore_)
	f = a.execqry("SELECT editmaxscore('"+b+"','"+c+"','"+session['scode']+"')", True) [0][0]
	return f
	
def deleteGradeItem(req,name_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(name_)
	f = a.execqry("SELECT deletegradeitem('"+b+"', '"+session['scode']+"')", True) [0][0]
	return f
	
def getStudentGrades(req,gradeitem_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(gradeitem_)
	f = a.execqry("SELECT getstudentgrades('"+b+"','"+session['scode']+"')", False) [0][0]
	return f
	
def addStudentGrade(req,studentid_,score_,gradeitem_):
	session = Session.Session(req)
	a = doSql()
	b = cgi.escape(studentid_)
	c = cgi.escape(score_)
	d = cgi.escape(gradeitem_)
	f = a.execqry("SELECT addstudentgrade('"+b+"','"+c+"','"+d+"','"+session['scode']+"')", True) [0][0]
	return f
	
def studentIdAutoComp(req):
	session = Session.Session(req)
	a = doSql()
	#f = a.execqry("SELECT addstudentgrade('"+b+"','"+c+"','"+d+"','"+session['scode']+"')", True) [0][0]
	#return [('2010-7171',), ('2008-1234',)]
	#return ['a','b','c']
	p = ''
	z = [('2010-7171',), ('2009-1625',)]
	for x in xrange(len(z)): 
		p = p + z[x][0] + '@'
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

