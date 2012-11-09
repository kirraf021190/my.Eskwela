from dosql import *
import cgi
import json
from mod_python import Session
from decimal import Decimal

def getClasses(req):
	session = Session.Session(req)
	a = doSql()
    	f = a.execqry("select getClasses('"+session['id']+"')", False)[0][0]
	return f

def getStudentClasses(req):
	session = Session.Session(req)
	a = doSql()
    	f = a.execqry("select getStudentClasses('"+session['id']+"')", False)[0][0]
	return f

def getStudentInfo(req):
	session = Session.Session(req)
	a = doSql()
	#session.delete() #end session
        return session['name']+"$"+session['id']

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


def addGrpPerformance(req, description, maxscore, period, date, grdcat):
	session = Session.Session(req)
	#k = cgi.escape(grp_perfID)
	e = cgi.escape(grdcat)
	g = cgi.escape(description)
	h = cgi.escape(maxscore)
	i = cgi.escape(period)
	#l = cgi.escape(cat_id)
	j = cgi.escape(date)
	k = doSql()
	f = k.execqry("select addgrp_performance('"+e+"', '"+g+"','"+h+"', '"+i+"', '"+j+"')", True)[0][0]
	return f+"$True"

def getGrpPerf(req):
	session = Session.Session(req)
	sectionId = session['sCode']
	a = doSql()
	f = a.execqry("select getgrp_performance('"+sectionId+"')", False)[0][0]
	return f


def remGrpPerf(req, groupPerfId):
	session = Session.Session(req)
	cleanedGroupPerfId = cgi.escape(groupPerfId)
	connection = doSql()
	f = connection.execqry("select remgrp_performance('"+cleanedGroupPerfId+"')", True)
	return True


def getPerformance(req, grp_perf_id):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select getperformance('"+grp_perf_id+"')", False)[0][0]
	return f



def getCat(req):
	session = Session.Session(req)
	a = doSql()

	f = a.execqry("select getcat('"+session['sCode']+"')", False)[0][0]
	g = f.split('@')
	options = ''
	count = 0
	for details in g:
		details1 = details.split('$')
		if(count < len(details)):
			options += '<option value="'+details1[1]+'">' +details1[0]+ '</option>'
		count += 1
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


def getAttend(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select getattendance('"+session['sCode']+"') ", False)[0][0]
	return f



def updateGradeItem(req, categoryId, groupPerfId, grpPerfDesc, maxScore, grpPerfDate, period):
	
	categoryId = cgi.escape(categoryId)	
	groupPerfId = cgi.escape(groupPerfId)
	grpPerfDesc = cgi.escape(grpPerfDesc) 
	maxScore = cgi.escape(maxScore) 	
	grpPerfDate = cgi.escape(grpPerfDate)
	period = cgi.escape(period)
	a = doSql()
	f = a.execqry("select updategrp_performance('"+categoryId+"', '"+groupPerfId+"', '"+grpPerfDesc+"', '"+maxScore+"', '"+grpPerfDate+"', '"+period+"')", True)
	return True


def updatePerformance(req, performanceId, scoreUpdate):
	session = Session.Session(req)
	performanceId = cgi.escape(performanceId) 
	scoreUpdate = cgi.escape(scoreUpdate)
	a = doSql()
	f = a.execqry("select updateperformance('"+performanceId+"', '"+scoreUpdate+"')", True)
	return True


def getScore(req):
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select getstudents('"+session['class']+"', '"+session['sy']+"', '"+session['subj']+"')", False)[0][0]
	return f


def addScore(req, grpPerfId, regId, score):
	session = Session.Session(req)	
	b = cgi.escape(grpPerfId)
	c = cgi.escape(regId)
	d = cgi.escape(score)
	e = doSql()
	f = e.execqry("select addscore('"+b+"','"+c+"','"+d+"','1')", True)
	return True

#Added as of 9-18-11
#Modified: 9-25-11
def getHeaderReport(req):
	
	session = Session.Session(req)
	a = doSql()
	f = a.execqry("select getheader('"+session['sCode']+"')", False)[0][0]
	results = '{"categories": ['
	categories = f.split('@')
	count = 1
	for details in categories:
		if(count == len(categories)):
			break
		splitCategory = details.split('$')
		results += '{"id":"'+splitCategory[0]+'", '
		results += '"category": "'+splitCategory[1]+'",'
		results += '"weight": "'+splitCategory[2]+'",'
		results += '"grpPerformance": ['
		g = a.execqry("select getGrpPerformances("+splitCategory[0]+")", False)[0][0]
		splitGrpPerf = g.split('@')
		count2 = 1
		for details1 in splitGrpPerf:
			if(count2 == len(splitGrpPerf)):
				break
			grpPerfDetails = details1.split('$')
			results += '{"grpPerfId": "'+grpPerfDetails[0]+'", '
			results += '"grpPerfName": "'+grpPerfDetails[1]+'", '
			results += '"items": "'+grpPerfDetails[2]+'" '
			results += '}'
			if(count2< len(splitGrpPerf)-1):
				results += ','
			count2 += 1
		results += ']}'
		if(count< len(categories)):
			results += ','
		count += 1
	results += ']}'
	return results

#added as of sept. 25

def getSectionStudent(req):
	session = Session.Session(req)
	a = doSql()
    	f = a.execqry("select getstudentforreports('"+session['sy']+"', '"+session['id']+"')", False)[0][0]
	return f

def getIndividualStudentReport(req):

	a = doSql()
	session = Session.Session(req)
	student = (a.execqry("select getstudentforreports('"+session['sy']+"', '"+session['id']+"')", False)[0][0]).split('@')
	return getGradesReport(session, student)	


def getStudentGradesReport(req):

	a = doSql()
	session = Session.Session(req)
	studentList = (a.execqry("select getstudents('"+session['class']+"', '"+session['sy']+"', '"+session['subj']+"')", False)[0][0]).split('@')
	return getGradesReport(session, studentList)


def getGradesReport(session, studentList):

	a = doSql()

	categoryList = (a.execqry("select getheader('"+session['sCode']+"')", False)[0][0]).split('@')

	categories = []
	catWeights = []
	gpIds = []
	gpMaxScores = []
	studScores = []
	 
	catItrCount = 1	
	for categoryItr in categoryList:

		categoryDetails = categoryItr.split('$')
		if(catItrCount == len(categoryList)):
			break		
		if(len(categoryDetails)==0):
			continue

		categories.append(categoryDetails[0])
		catWeights.append(categoryDetails[2])
		
		cat_gp_ids = []
		cat_gp_max = []		
		cat_stud_scores = []

		grpPerfList = (a.execqry("select getGrpPerformances("+categoryDetails[0]+")", False)[0][0]).split('@')
		
		grpPerfCount = 1
		for grpPerfItr in grpPerfList:

			grpPerfDetails = grpPerfItr.split('$')
			if(grpPerfCount == len(grpPerfList)):
				break

			if(len(grpPerfDetails)==0):
				continue

			cat_gp_ids.append(grpPerfDetails[0])
			cat_gp_max.append(grpPerfDetails[2])
			
			grpPerfCount += 1

		studCount = 1
		for studentList1 in studentList:
			ind_stud_scores = []	
			studentDetails = studentList1.split('$')

			if(studCount == len(studentList)):
				break
			if(len(studentDetails)==0):
				continue
			grpPerfCount2 = 1
			for grpPerfItr2 in grpPerfList:

				grpPerfDetails2 = grpPerfItr2.split('$')
				if(grpPerfCount2 == len(grpPerfList)):
					break

				if(len(grpPerfDetails2)==0):
					continue
				try:
					score = a.execqry("select getscore("+grpPerfDetails2[0]+", "+studentDetails[2]+")", False)[0][0]
					ind_stud_scores.append(score)
				except:
					break
				
				grpPerfCount2 += 1

			studCount += 1

			cat_stud_scores.append(ind_stud_scores)

		gpIds.append(cat_gp_ids) 
		gpMaxScores.append(cat_gp_max)
		studScores.append(cat_stud_scores)
		catItrCount += 1
	grades = computeGrades(catWeights, gpMaxScores, studScores, session['sCode'])
	json =  jsonReport(categories, gpIds, grades, studentList, studScores, session['sCode'])
	return json

def jsonReport(categories, gpIds, studGrades, studentList, studScores, semSubjId):
	#return studGrades
		
	report = '{"data":['
	for i in range(0, len(studentList)-1):
		studDetails = studentList[i].split('$')
		report += '{"student": "'+studDetails[0]+'", '
		report += '"scale": "'+str(studGrades[2][i])+'", '
		report += '"grade": '+str(studGrades[1][i])+', '
		report += '"categories": ['
		for j in range(0, len(categories)):
			report += '{"catId": '+ categories[j]+', '
			report += '"total": '+str(studGrades[0][i][j])+', '
			report += '"grpPerformances": ['
			for k in range(0, len(gpIds)):
				try:
					report += '{"grpPerfId": '+gpIds[j][k]+', '
					report += '"score": '+studScores[j][i][k]+'}'
					if(k<len(gpIds[j])-1):
						report += ', '
				except:
					continue
			report += ']}'
			if(j<len(categories)-1):
				report += ','
		report += ']}'
		if(i<len(studentList)-2):
			report += ','
	report += ']}'
	return report
			
	

def computeGrades(catWeights, gpMaxScores, studScores, semSubjId):

	a = doSql()
	studGrades = []
	scales = []
	catGrades = []
	catWeightTotal = 0
	numStudents = len(studScores[0])
	#return numStudents
	for catWeight in catWeights:
		catWeightTotal += float(catWeight)

	for studs in range(0, numStudents):
		catGrade = []
		for i in range(0, len(catWeights)):
			weight = catWeights[i]
			maxscores = gpMaxScores[i]
			maxscoreTotal = 0;
			
			partialGrade = 0
			for j in range(0, len(maxscores)):
				partialGrade += float(studScores[i][studs][j])
				maxscoreTotal += float(maxscores[j])
			
			if(maxscoreTotal > 0):
				catGrade.append(partialGrade/maxscoreTotal)
			else:
				catGrade.append(1)
		partialGrade1 = 0
		for k in range(len(catGrade)):
			partialGrade1 += catGrade[k]*float(catWeights[k])
	        studGrade = partialGrade1/catWeightTotal
		studGrades.append(studGrade)
		a = doSql()
		twoDecimalGrade = Decimal(str(studGrade*100)).quantize(Decimal('0.01'))
		scaleGrade = a.execqry("select getGradeScale("+semSubjId+","+str(twoDecimalGrade)+" );", False)[0][0]
		
		scales.append(scaleGrade)
		catGrades.append(catGrade)
	return [catGrades, studGrades, scales]
 			

#end here

