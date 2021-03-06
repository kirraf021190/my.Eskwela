import psycopg2, string

def index(req):
    formData = req.form
    userRole = formData['userRole']
    subjectID = formData['ss']
    
    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();
    
    #Getting Section Information...
    arg1 = "SELECT section_information(%s)"; arg2 = (subjectID, )
    curr.execute(arg1, arg2); data = curr.fetchall();
    dataString = data[0][0]
    
    sectionInfo = string.split(dataString, '#')

    html =  """
        <script>
        $(function(){
            $('#show-attendance-btn').click(function(){ _pageHandler.generate_my_attendance_results();});
            $('#show-grades-btn').click(function(){ _pageHandler.generate_my_grade_results(); });
            $('#attend-session-btn').click(function(){ _pageHandler.attend_session(); });

            $('#show-grade-list-btn').click(function(){ _pageHandler.show_grade_list(); });
            $('#show-class-list-btn').click(function(){_pageHandler.show_class_list();});
            $('#waitlist-btn').click(function(){ _pageHandler.show_attendance_waitlist(); });
            
            $('#back-button-cont').show(0);
            $('#back-button').click(function(){
                _pageHandler.generate_my_subjects();
            });
        });
        </script>    
        <ul data-role='listview'>
            <li align='center'><h2 align='center'> Subject Information </h2> </li>           
            <li style='font-weight:normal;'>
                <div class='ui-grid-a'>
                    <div class='ui-block-a'><strong>Subject Code:</strong></div>
                    <div class='ui-block-b'>"""+sectionInfo[1]+"""("""+sectionInfo[2]+""")</div>
                </div>
                <div class='ui-grid-a'>
                    <div class='ui-block-a'><strong>Description:</strong></div>
                    <div class='ui-block-b'>"""+sectionInfo[3]+"""</div>
                </div>
                <div class='ui-grid-a'>
                    <div class='ui-block-a'><strong>Schedule:</strong></div>
                    <div class='ui-block-b'>"""+sectionInfo[4]+"""("""+sectionInfo[5]+""")</div>
                </div>
                <div class='ui-grid-a'>
                    <div class='ui-block-a'><strong>Room:</strong></div>
                    <div class='ui-block-b'>"""+sectionInfo[6]+"""</div>
                </div>
                <div class='ui-grid-a'>
                    <div class='ui-block-a'><strong>Instructor:</strong></div>
                    <div class='ui-block-b'>Prof. Eddie B. Singko</div>
                </div>
            </li>
            <li data-role='list-divider'> Please select below to continue: </li> """;

    if (userRole == "STUDENT"):
        html += """ <li id='show-attendance-btn'><a href='#'> Show Attendance </a></li>
                <li id='show-grades-btn'><a href='#'> Show Grades </a></li>
                <li id='attend-session-btn'><a href='#'> Attend Session </a></li>"""
    elif (userRole == "PARENT"):
         html += """ <li id='show-attendance-btn'><a href='#'> Show Attendance </a></li>
                <li id='show-grades-btn'><a href='#'> Show Grades </a></li>"""
    elif (userRole == "FACULTY"):
        html += """<li id='show-class-list-btn'><a href='#'> Show Class List </a></li>
                  <li id='show-grade-list-btn'><a href='#'> Student Grade List </a></li>
                  <li id='waitlist-btn'><a href='#'> View Attendance Waitlist </a></li> """

    html += """ </ul> """;

    return html
