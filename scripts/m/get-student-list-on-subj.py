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
    subjInfoArray = get_subject_information(db, sectID)

    
    #Close
    #db.close()

    q0 = "SELECT enrolled("+str(sectID)+")";
    query = db.query(q0); result = query.dictresult()

    html = """
        <div id='main-menu-adv-info'>
	    <div class='ui-bar-c' style='padding:0% 0% 0% 10%;margin:-6% 0% 5% -10%;width:110%;'>
		<h3> """+subjInfoArray[0]+"""["""+subjInfoArray[1]+"""] Class List </h3>
                <div style='margin-top:-15px;padding-bottom:10px;'> <32> Student(s) </div>
	    </div>
	</div>
	<ul data-role="listview" data-filter='true'>
    """
    if (len(result) == 0):
        html += "<li>Ooops! There are no students enrolled in your subject! Please check your section.</li>"
    else:
        for studentitem in result:
            student = studentitem['enrolled']
            studentinfo = get_student_info(student, db)
            html += "<li><a href='Javascript:_statsMod.viewStudentAttendanceAsFaculty("+'"'+str(student)+'"'+")'><img src='http://localhost/eskwela.iit.edu.ph/html_mobile/img/"+str(student)+".jpg' />"
            html += str(student)+"<h3 style='font-size:130%;margin:0px;padding:0px;'>"+studentinfo[2]+"</h3>"
            html += "<div style='font-size:70%;margin-top:0px;padding-top:0px;'>"+studentinfo[0]+" "+studentinfo[2][0]+". | "+studentinfo[3]+"-"+studentinfo[5]+" </div></a></li>";

    html += "</ul>"
    
    return html;
    

def get_subject_information(d, s):
    q = "SELECT section_information("+str(s)+")"
    query = d.query(q); result = query.dictresult();

    return string.split(result[0]['section_information'], '#')

def get_student_info(s, d):
    q0 = "SELECT student_information('"+s+"')";
    query = d.query(q0); result = query.dictresult()

    return string.split(result[0]['student_information'], "#")


    return None
