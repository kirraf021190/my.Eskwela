import pg, string


def index(req):
    form = req.form
    subjSectID = form['subjSectID']
    acctID = form['acctID']

    #Connect to Database
    db = pg.connect('myEskwela', 'localhost', 5432, None, None, 'postgres', 'password')

    #Get Section Name/Course Name
    subjSectArray = get_subj_section_array(subjSectID, db)

    #AttendedSessions
    attendedSessions = get_attended_sessions(acctID, subjSectID, 6, db);
    lastSession = get_last_session(acctID, subjSectID, 6, db);
        
    html = """
        <script type='text/javascript'>
        $(function(){
            $('#report-actions-tab').change(function(){
                var option = $(this).val();

                if (option != 0){
                    //alert(option);
                    _queryHandler.setRecipientType(option);
                    $.mobile.changePage('dialog_html/send-stats.html', {role:'dialog', data:option}); 
                }

                //Set the value back to option=0
                $(this).val(0);
            });
        });
        </script>
        <div id='basic-cont' class='ui-bar-c' style='padding:0% 0% 0% 10%;margin:-6% 0% 5% -10%;width:110%;'>
          <h4> Attendance Report for """+subjSectArray[0]+"""["""+subjSectArray[1]+"""]</h4>
			<div id='basic-stat-cont'>
						<div class='ui-grid-a'>
							<div class='ui-block-a'>Status:</div>
							<div class='ui-block-b'>
								Regular Attendee
							</div>
						</div>
						<div class='ui-grid-a'>
							<div class='ui-block-a'>Attended Sessions:</div>
							<div class='ui-block-b'>
								"""+attendedSessions+"""
							</div>
						</div>
						<div class='ui-grid-a'>
							<div class='ui-block-a'>Last Session Attended:</div>
							<div class='ui-block-b'>
								"""+str(lastSession)+"""
							</div>
						</div>
					</div>
					<select id="report-actions-tab" data-native-menu='false'>
						<option value=0> Report Actions </option>
						<option value='EMAIL'> Send Stats to Email </option>
						<option value='SMS'> Send Stats to SMS </option>
					</select><br />
                </div>
			<div id='list-cont'>
			<ul data-role='listview'>
				<li data-role="list-divider">My Attendance Table</li> """

    mylist = dict()
	 
    q0 = "SELECT student_sessions_attended('"+acctID+"', "+str(subjSectID)+", 6)"
    query = db.query(q0)
    result = query.dictresult()
    if(len(result) != 0):
        for a in result:
            mylist[a['student_sessions_attended']] = "Attended"

    q1 = "SELECT student_sessions_absented('"+acctID+"', "+str(subjSectID)+", 6)"
    query1 = db.query(q1)
    result1 = query1.dictresult()
    if (len(result1) != 0):
        for b in result1:
            theKey = b['student_sessions_absented']
            mylist[theKey] = "Absent"
    else:
        print "Nothing goes here"

    #Iterate thru the values...
    i = 1
    for itemkey in sorted(mylist.keys()):
        html += "<li>#"+str(i)+": "+itemkey+" ("+mylist[itemkey]+")</li>"
        i = i+1

    html += """
			</ul>			
			</div>

        """

    return html

def get_subj_section_array(s, d):
    q = "SELECT section_information("+str(s)+")"
    query = d.query(q)
    result = query.dictresult()

    stringArray = string.split(result[0]['section_information'], '#')
    return [stringArray[0], stringArray[1]]

def get_last_session(studentID, sectionIDInt, termIDInt, d):
    q = "SELECT student_last_attended('"+studentID+"', "+str(sectionIDInt)+", "+str(termIDInt)+")" #section_information("+str(s)+")"
    query = d.query(q)
    result = query.dictresult()

    return result[0]['student_last_attended']

def get_absence_count(studentID, sectionIDInt, termIDInt, d):
    q = "SELECT student_absence_count ('"+studentID+"', "+str(sectionIDInt)+", "+str(termIDInt)+")" #section_information("+str(s)+")"
    query = d.query(q)
    result = query.dictresult()

    return result[0]['student_absence_count']

def get_presence_count(studentID, sectionIDInt, termIDInt, d):
    q = "SELECT student_attendance_count ('"+studentID+"', "+str(sectionIDInt)+", "+str(termIDInt)+")" #section_information("+str(s)+")"
    query = d.query(q)
    result = query.dictresult()

    return result[0]['student_attendance_count']

def get_attended_sessions(s, i, t, d):
    #Get presence Count
    presents = get_presence_count(s, i, t, d)
    absents = get_absence_count(s, i, t, d)
    total = absents+presents

    return str(presents)+"/"+str(total)+" ("+str(absents)+" absence(s))"

def get_current_term(d):                    
    qString = "SELECT current_term()"

    return 4


