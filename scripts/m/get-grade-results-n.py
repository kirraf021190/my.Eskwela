import string, psycopg2

def index(req):
    form = req.form
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

    #Getting GradeItems and Tentative Standing...
    arg1 = "SELECT get_grade_item_entry_in_section(%s, %s)"; arg2 = (acctID, subjectID,)
    curr.execute(arg1, arg2); data = curr.fetchall(); 

    gradeItemList = []; totalPerfectScore = 0; totalAllotedScore = 0
    for item in data:
        #if (item[0] != None):
        content = string.split(item[0], '#')
        gradeItemList.append(content)

        totalPerfectScore = totalPerfectScore + float(content[3])
        totalAllotedScore = totalAllotedScore + float(content[2])


    #Getting percentage
    percentage = get_percentage(float(totalAllotedScore), float(totalPerfectScore))

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
      <h2> Student Grade Report </h2>
           <div style='font-weight:normal;font-size:80%;'>
             <div class='ui-grid-b'>
                <div class='ui-block-a'><strong> Subject Code:</strong> </div>
                <div class='ui-block-b'> """+sectionInfo[1]+"""("""+sectionInfo[2]+""")</div>
             </div>
             <div class='ui-grid-b'>
                <div class='ui-block-a'><strong> Standing:</strong> </div>
                <div class='ui-block-b' style='width:50%'> """+str(totalAllotedScore)+"""/"""+str(totalPerfectScore)+""" 
                    ("""+str(percentage)+"""%) </div>
             </div>
            <br />
             <button> Send Stats to Email </button>
           </div>
      </div>
      <div style='overflow-y:auto;padding:15px;margin:-15px;height:165px;'>
          <ul data-role='listview' data-filter='true'>
            <!-- TODO: Put everything on the line here -->
            <!--      i.e. [Quiz] 09/19/2012 (9/10)    -->
      """;

    for item in gradeItemList:
        html += """
           <li>
                ["""+item[0]+"""] """+item[1]+""" - <br />"""+item[4]+""" ("""+item[2]+"""/"""+item[3]+""")
            </li>
        """;


    html += """      
          </ul>
      </div>

    """;
    
    #Closing and Returning...
    conn.close(); curr.close();
    return html;


def convertStr(s):
 	"""Convert string to either int or float."""
 	try:
 		ret = int(s)
 	except ValueError:
 		ret = float(s)
     	return ret

def get_percentage(a, b):
    if (a == 0 and b == 0):
        return 0
    else:
        return (a/b)*100
