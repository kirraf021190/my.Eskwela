import pg, pgdb, string

def index(req):
    form = req.form
    
    acct = form['acct']
    role = form['role']
  
    # Connecting to Database...
    db = pg.connect('myEskwela', 'localhost', 5432, None, None, 'postgres', 'password')
    
    # Query for the Subject List using Stored Proc
    currentSem = get_current_semester(db)

    #Check first Role...
    html = '<ul id="student-subjects-list-object" data-role="listview">'
    if (role == "STUDENT"):
        q0 = "SELECT student_load('"+acct+"', "+str(currentSem)+")"
        query0 = db.query(q0); result0 = query0.dictresult()

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
    
    elif (role == "FACULTY"):
        q0 = "SELECT faculty_load('"+acct+"', "+str(currentSem)+")"
        query0 = db.query(q0); result0 = query0.dictresult();

        html += "<li data-role='list-divider'>These are your assigned subjects. <br /> S.Y:  2012-2013</li>"

        for sect in result0:
            section = sect['faculty_load']
        
            q1 = "SELECT section_information("+str(section)+")"
            query1 = db.query(q1)
            result1 = query1.dictresult()

            subjectCode = result1[0]['section_information']
            sectionInfoArray = string.split(subjectCode, '#')

            # Parse it to html
            subjSectionCode = sectionInfoArray[0] + "@" + sectionInfoArray[1]
            html = concat(html, generate_li_item(subjSectionCode, db, section))
    elif (role == "PARENT"):
        html += "<li data-role='list-divider'>Showing your children enrolled in IIT:<br />S.Y. 2012-2013</li>"
        q0 = "SELECT get_children('"+acct+"')";
        query = db.query(q0); result = query.dictresult();

        for child in result:
            studentID = child['get_children']
            childInfo = get_child_information(studentID, db)

            html += "<li><a href='Javascript:_statsMod.redirectToSubjectListAsParent("+'"'+studentID+'"'+")'>"
            html += "<img src='http://localhost/eskwela.iit.edu.ph/html_mobile/img/"+studentID+".jpg' />"
            html += studentID+"<h3 style='font-size:130%;margin:0px;padding:0px;'>"+childInfo[2]+"</h3>"
            html += "<div style='font-size:70%;margin-top:0px;padding-top:0px;'>"+childInfo[0]+" "+childInfo[1]+". | "+childInfo[3]+"-"+childInfo[5]+" </div></a></li>";
         
    
    # Close DB
    db.close()
    
    # Return it...
    return html

#Only to be used for PARENT roles only
def get_child_information(s, d):
    q0 = "SELECT student_information('"+s+"')"
    query = d.query(q0); result = query.dictresult();

    return string.split(result[0]['student_information'], '#');

#Generate List Item
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

    query = d.query("SELECT getcurrsem()") #update this...
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
