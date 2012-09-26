import pg, string

def index(req):
    form = req.form
    #ajaxData = string.split(form['subjSectID'], '@')

    #subjectID = ajaxData[0]
    #sectionID = ajaxData[1]
    sectID  = form['subjSectID']
    role    = form['userRole']

    # Connecting to Database...
    db = pg.connect('myEskwela', 'localhost', 5432, None, None, 'postgres', 'password')
    
    #cacheQuery = db.query("SELECT get_subject_information('"+subjectID+"', '"+sectionID+"')")
    q = "SELECT section_information("+str(sectID)+")"
    query = db.query(q)
    result = query.dictresult()
    rString = result[0]['section_information']
    subjectInfoArray = string.split(rString, '#')

    courseName        = subjectInfoArray[0]
    courseSection     = subjectInfoArray[1]
    courseDescription = subjectInfoArray[2] #get_subject_description(cacheQuery)
    courseSched       = subjectInfoArray[3]+" "+subjectInfoArray[4]+" ("+subjectInfoArray[5]+")";
    courseInstructor  = get_professor_name(sectID, db)
    courseUnits       = str(subjectInfoArray[6])

    #Close
    db.close()
    
    html = """
        <div id='main-menu-adv-info'>
				<div class='ui-bar-c' style='padding:0% 0% 0% 10%;margin:-6% 0% 5% -10%;width:110%;'>
					<h3> """+courseName+""" ["""+courseSection+"""] </h3>
				</div>
				<div class='ui-grid-a'>
					<div class='ui-block-a'>Description:</div>
					<div class='ui-block-b'>
						<i>"""+courseDescription+"""</i>
					</div>
				</div>
				<div class='ui-grid-a'>
					<div class='ui-block-a'>Instructor:</div>
					<div class='ui-block-b'>"""+courseInstructor+"""</div>
				</div>
				<div class='ui-grid-a'>
					<div class='ui-block-a'>Schedule/Room</div>
					<div class='ui-block-b'>"""+courseSched+"""</div>
				</div>
				<div class='ui-grid-a'>
					<div class='ui-block-a'>Units:</div>
					<div class='ui-block-b'>"""+courseUnits+""" unit(s)</div>
				</div>
				
			</div>
			<br />
    """
    if (role == "STUDENT" or role == "PARENT"):
        html += """
			<a href='subject-report.html' data-role='button'>View My Attendance Stats</a>
			<a href='#' data-rel='back' data-role='button'>View My Grade Stats</a>		
                """

    elif (role == "FACULTY"):
        html += """
                        <a href='subj-student-list.html' data-role='button'>View Student Attendance</a>
			<a href='#' data-rel='back' data-role='button'>Add Grade Churva</a>		
            """


    return html

def get_subject_description(query):
    result = query.dictresult()
    value = string.split(result[0]['get_subject_information'], ',')

    return value[6]

def get_schedule_and_room(query):
    result = query.dictresult()
    value = string.split(result[0]['get_subject_information'], ',')

    return value[4]+" ["+value[2]+"]"

def get_professor_name(sectionID, d):
    # Get Professor ID first...
    q0 = "SELECT section_faculty("+str(sectionID)+")"
    query0 = d.query(q0)
    result0 = query0.dictresult()

    profID = result0[0]['section_faculty']
    #Then get the prof name...
    q1 = "SELECT faculty_information('"+profID+"')"
    query1 = d.query(q1)
    result1 = query1.dictresult()

    profileInfoArray = string.split(result1[0]['faculty_information'], '#')

    name = "Prof. "+profileInfoArray[0]+" "+profileInfoArray[1]+" "+profileInfoArray[2]
    return name
