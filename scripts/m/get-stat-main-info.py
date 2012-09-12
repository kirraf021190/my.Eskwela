import pg, pgdb, string

def index(req):
    form = req.form
    
    acct = "2009-1625" #form['acct'] #"2009-0661"
  
    # Connecting to Database...
    db = pg.connect('myEskwela', 'localhost', 5432, None, None, 'postgres', 'password')
    
    # Query for the Subject List using Stored Proc
    currentSem = get_current_semester(db)
    
    q0 = "SELECT student_load('"+acct+"', "+str(currentSem)+")"
    query0 = db.query(q0)
    result0 = query0.dictresult()

    html = '<ul id="student-subjects-list-object" data-role="listview">'
    html += "<li data-role='list-divider'>These are your enrolled subjects:<br /> S.Y:  2012-2013</li>"

    for sect in result0:
        section = sect['student_load']
        
        q1 = "SELECT section_information("+str(section)+")"
        query1 = db.query(q1)
        result1 = query1.dictresult()

        subjectCode = result1[0]['section_information']
        sectionInfoArray = string.split(subjectCode, '#')

        # Parse it to html
        subjSectionCode = sectionInfoArray[0] + "@" + sectionInfoArray[1]
        html = concat(html, generate_li_item(subjSectionCode, db, section))
    
    # Close DB
    db.close()
    
    # Return it...
    return html

def generate_li_item(subjectSectionID, d, ss):
    #Get the subject name, section, instructor...
    tempSubjectSection = string.split(subjectSectionID, '@')
    subjectCode = tempSubjectSection[0]
    section     = tempSubjectSection[1]
    #subQuery    = d.query("SELECT get_subject_information('"+subjectCode+"', '"+section+"')")

    #subjectDesc = get_subject_description(subQuery)
    #schedule    = get_schedule_and_room(subQuery)
    #instructor  = ""
    #Parse it to html..
    param = str(ss) #"'"+subjectSectionID+"'"
    html = '<li id="'+subjectSectionID+'"><a href="Javascript:_statsMod.openSubjectInfo('+param+')">'
    html = concat(html, subjectCode+" ["+section+"]")
    html = concat(html, '</a></li>')
    return html
 

def get_current_semester(d):
    #This is accrding to the Database...
    #Uses getcurrsem() fcn of DB

    query = d.query("SELECT current_term()") #update this...
    res = query.dictresult()

    return res[0]['current_term']

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
