import sys, os, re
import pg, pgdb
import string


def index(req):
    #Extracting the POST variable
    form = req.form
    acct = form['userAccountID']

    # Connecting to Database...
    db = pg.connect('myEskwela', 'localhost', 5432, None, None, 'postgres', 'password')
    
    # Query for the Subject List using Stored Proc
    currentSem = get_current_semester(db)
    
    q0 = "SELECT get_current_subject('"+acct+"', '"+currentSem+"')"
    query0 = db.query(q0)
    result0 = query0.dictresult()

    html = '<ul id="student-subjects-list-object" data-role="listview" data-filter="true">'

    for sect in result0:
        section = sect['get_current_subject']
        q1 = "SELECT get_subject_code_of_section_code('"+section+"')"
        query1 = db.query(q1)
        result1 = query1.dictresult()

        subjectCode = result1[0]['get_subject_code_of_section_code']
        
        # Parse it to html
        subjSectionCode = subjectCode + "@" + section
        html = concat(html, generate_li_item(subjSectionCode, db))
    
    # Close DB
    
    # Return it...
    return html

def generate_li_item(subjectSectionID, d):
    #Get the subject name, section, instructor...
    tempSubjectSection = string.split(subjectSectionID, '@')
    subjectCode = tempSubjectSection[0]
    section     = tempSubjectSection[1]
    subQuery    = d.query("SELECT get_subject_information('"+subjectCode+"', '"+section+"')")

    
    subjectDesc = get_subject_description(subQuery)
    schedule    = get_schedule_and_room(subQuery)
    instructor  = ""
    #Parse it to html..
    param = "'"+subjectSectionID+"'"
    html = '<li id="'+subjectSectionID+'"><a href="Javascript:_queryHandler.doQuery('+param+')">'
    html = concat(html, subjectCode+" ["+section+"]")
    html = concat(html, '<div style="font-size:75%">'+subjectDesc+schedule+'</div></a></li>')
    return html

def get_current_semester(d):
    #This is accrding to the Database...
    #Uses getcurrsem() fcn of DB

    query = d.query("SELECT getcurrsem()")
    res = query.dictresult()

    return res[0]['getcurrsem']

def concat(str1, str2):
    return str1 + str2

def get_subject_description(query):
    result = query.dictresult()
    value = string.split(result[0]['get_subject_information'], ',')

    return value[6]

def get_schedule_and_room(query):
    result = query.dictresult()
    value = string.split(result[0]['get_subject_information'], ',')

    return " - "+value[4]+" ["+value[2]+"]"
