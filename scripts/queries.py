from dosql import *
import cgi
from mod_python import Session
import time
import os
import form

def getClasses(req):
	session = Session.Session(req)
	a = doSql()
    	f = a.execqry("select getClasses('"+session['id']+"')", False)[0][0]
	return f

def getTeacherInfo(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select picture from faculty where fac_id = '"+session['id']+"' limit 1", False)[0][0]
	#session.delete() #end session
        return session['name']+"$"+session['id']+"$"+session['dept']+"$"+session['college']+"$"+f

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

def addAttendance(req, idnum_, studentname_):
	session = Session.Session(req)	
	b = cgi.escape(idnum_)
	c = cgi.escape(studentname_)
	x = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
	e = doSql()
	#f = e.execqry("INSERT INTO attendancetemp VALUES('"+b+"','"+c+"','"+x+"','"+session['sCode']+"')", True)
	f = e.execqry("SELECT addattend('"+b+"','"+c+"','"+x+"','"+session['subj']+"')", True)
	#f = e.execqry("SELECT addattend('"+c+"')", True)

	return True

	
def changepass(req, newpass_, oldpass_):
	session = Session.Session(req)
	e = doSql()
	b = cgi.escape(newpass_)
	c = cgi.escape(oldpass_)	
	#Query to retrieve SALT from DATABASE
	#oldHashPass = encryptPass(salt,c)
	#newSalt = generateSalt()
	#newHashPass = encryptPass(newSalt,b)
	f = a.execqry("SELECT changepass('"+session['id']+"','"+b+"','"+c+"')", True)
	return f
	
def resetPassword(req):
	session = Session.Session(req)
	randPassword = os.urandom(string_length)
	#salt = generateSalt()
	#hashPass = encryptPass(salt, randPassword)
	a = doSql()
	f = a.execqry("update user_account set password = '"+randPassword+"' where username = '"+f+"'", true)
	f = a.execqry("SELECT changepass('"+randPassword+"','"+f+"')", True)
	return True

#def registerUser(fname, mname, lname, studentName, studentId, location):
#	a = doSql()
#	b = cgi.escape(fname)
#	c = cgi.escape(mname)
#	d = cgi.escape(lname)
#	if (studentName != "")
		#stored proc for this. Select accountId of student by student name specification
#		student = a.execqry("select accountId where studentname = '"+studentName+"').
#	else
#		student = "".
#	if (studentId != "")
		#stored proc for this. Select accountId of student by student Id specification
#		student = a.execqry("select accountId where studentId = '"+studentId+"').
#	e = cgi.escape(location)
	#stored proc for this. update user accounts with new parent account.
#	f = a.execqry("update user_account set fname, mname, lname, student, location", true).
#	return True

#def linkUsers(req, user):
#	session = Session.Session(req)
#	user = cgi.escape(user)
#	a = doSql()
#	f = a.execqry("select requestlink('"+session['id']+"', '"+user+"', true)	
#   return f

def showSubjects(req, idnum):
	a = doSql()
	b = cgi.escape(idnum)
	f = a.execqry("SELECT * enrolledsubj where idnum = '"+b+"')
	return f

def getGradeSubject(req, idnum, subj):
	a = doSql()
	b = cgi.escape(idnum)
	c = cgi.escape(subj)
	f = a.eecqry("SELECT * grades where idnum = '"+b+"', subj = '"+c+'')
	return f
