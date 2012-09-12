import pg, string

def index(req):
    form = req.form
    tempQuery = form['query']
    query = tempQuery[1:-1]

    # Connecting to Database...
    db = pg.connect('myEskwela', 'localhost', 5432, None, None, 'postgres', 'password')

    objects = string.split(query, ',')

    #Caching data 
    studentIDNumber  = objects[3]

    subjectTempSection = string.split(objects[4], ':')
    #courseName = subjectTempSection[0]
    #sectionID  = subjectTempSection[1]

    courseTemp = string.split(subjectTempSection[1], '@')
    preQuery   = db.query("SELECT get_subject_information('"+courseTemp[0]+"', '"+courseTemp[1]+"')")

    html0 = "<h3>"+courseTemp[0]+" - "+courseTemp[1]+"</h3>"
    html1 = html0 + """
		<div class='ui-grid-a'>
		    <div class='ui-block-a'>
			<b>Description:</b> """+ get_subject_description(preQuery) + """
			<br />
			<b>Schedule:</b>
			MWF (12:00-9:00)
			<br />
			<b>Instructor:</b>
			Prof. Eddie B. Singko
			</div>
			<div class='ui-block-b'>
			    <b><i>Attendance Overview</i></b><br />
			    <b> Attendances: </b> 10/12 <br />
			    <b> Status: </b> Regular <br />
			    <b> Last Class Attended: </b> 09/09/11 <br />
			</div>
		</div>	

    """
    
    return html1

    
def get_subject_description(query):
    result = query.dictresult()
    value = string.split(result[0]['get_subject_information'], ',')

    return value[6]
