import psycopg2, string

def index(req):
    form = req.form; 
    subjectID = form['s']
    acctID = form['i']
    
    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();
    
    #Getting Section Information...
    arg1 = "SELECT section_information(%s)"; arg2 = (subjectID, )
    curr.execute(arg1, arg2); data = curr.fetchall();
    dataString = data[0][0]
    
    sectionInfo = string.split(dataString, '#')
    
    #Getting Total Attendances...
    arg1 = "SELECT student_attendance_count(%s, %s)"; arg2 = (acctID, subjectID)
    curr.execute(arg1, arg2); data = curr.fetchall(); attendedClasses = data[0][0];
    arg1 = "SELECT student_absence_count(%s, %s)"; arg2 = (acctID, subjectID)
    curr.execute(arg1, arg2); data = curr.fetchall(); absentClasses = data[0][0];
    totalClasses = attendedClasses+absentClasses;
    
    #Getting Last Session Attended...
    arg1 = "SELECT student_last_attended(%s, %s)"; arg2 = (acctID, subjectID)
    curr.execute(arg1, arg2); data = curr.fetchall();
    date = str(data[0][0])
    
    html = """
    <script>
    $(function(){
        $('#back-button').click(function(){
            _pageHandler.generate_subject_info_page();
            //alert();
        });
    });
    </script>
    <div class='ui-bar-c' style='padding:0% 0% 0% 10%;margin:-6% 0% 5% -10%;width:105%;'>
      <h2> Attendance Report </h2>
           <div style='font-weight:normal;font-size:80%;'>
             <div class='ui-grid-b'>
                <div class='ui-block-a'><strong> Subject Code:</strong> </div>
                <div class='ui-block-b'> """+sectionInfo[1]+"""("""+sectionInfo[2]+""")</div>
             </div>
             <div class='ui-grid-b'>
                <div class='ui-block-a'><strong> Attendances:</strong> </div>
                <div class='ui-block-b'> """+str(attendedClasses)+"""/"""+str(totalClasses)+""" 
                        ("""+str(show_percentage(attendedClasses, totalClasses))+"""%) </div>
             </div>
             <div class='ui-grid-b'>
                <div class='ui-block-a'><strong> Last Session:</strong></div>
                <div class='ui-block-b'>"""+date+"""</div>
             </div><br />
             <button> Send Stats to Email </button>
           </div>
      </div>
      <div style='overflow-y:auto;padding:15px;margin:-15px;height:165px;'>
          <ul data-role='listview' data-filter='true'>""";
    # Grab data from DB...
    attendances = [];
    
    arg1 = "SELECT student_sessions_absented_information(%s, %s)"; arg2 = (acctID, subjectID)
    curr.execute(arg1, arg2); data = curr.fetchall();
    for item in data:
        stringa = item[0]; itemArray = string.split(stringa, '#');
        itemArray.append('ABSENT'); attendances.append(itemArray)
              
    arg1 = "SELECT student_sessions_attended_information(%s, %s)"; arg2 = (acctID, subjectID)
    curr.execute(arg1, arg2); data = curr.fetchall();
    for item in data:
        stringa = item[0]; itemArray = string.split(stringa, '#');
        itemArray.append('ATTENDED'); attendances.append(itemArray)
     
    #Printing items in attendances attendances.sort(None, 0, True)
    counter = 1; attendances.sort(None, None, True)
    for item in attendances:
        status = "";
        if (item[2] == "ONGOING"):
            status = "("+item[2]+")"
        
        html += "<li>"+str(counter)+") "+item[1]+" - "+item[3]+" "+status+"</li>"
        counter += 1;
        
               
    
      #        <li> test ni siya </li>
      #        <li> test ni siya </li>
      #        <li> test napud ni </li>
      #        <li> test ni siya </li>
      #        <li> test ni siya </li>
      #        <li> test napud ni </li>       
    
    html+="""    </ul>
      </div>

    """; 
    return html


def show_percentage(a, b):
    return (float(a)/float(b))*100;