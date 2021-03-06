import psycopg2, string, datetime

def index(req):
    form = req.form;
    studentID = form['st']; sectionID = form['se'];
    
    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();
    
    #Get section Information...
    arg1 = "SELECT section_information(%s)"; arg2 = (sectionID, )
    curr.execute(arg1, arg2); data = curr.fetchall(); sectionInfo = string.split(data[0][0], '#')
    
    #Get Last Attended Session
    last_attended = ""
    arg1 = "SELECT student_last_attended(%s, %s)"; arg2 = (studentID, sectionID);
    curr.execute(arg1, arg2); data = curr.fetchall(); 
    if (data[0][0] == None):
        last_attended = "None"
    else:
        last_attended = str(data[0][0]);
    
    #Get Status of CurrentSession...
    arg1 = "SELECT get_ongoing_session(%s)"; arg2 = (sectionID,);
    curr.execute(arg1, arg2); data = curr.fetchall(); currentSessionID = int(data[0][0]);
    
    hasSession = True;
    if currentSessionID == 0:
        hasSession = False;
    else:
        arg1 = "SELECT class_session_information(%s)"; arg2 = (currentSessionID,)
        curr.execute(arg1, arg2); data = curr.fetchall(); currentSession = string.split(data[0][0], '#');
    
    #Get Current Date and Time
    now = datetime.datetime.now()
    currentDate = str(now.year)+"-"+str(now.month)+"-"+str(now.day)
    currentTime = str(now.hour)+"-"+str(now.minute);
    
    html = """
    
    <script>
    $(function(){
        $('#attend-status').hide(0);
        $('#attend-session-btn').click(function(){
            $('#attend-btn-cont').hide('fade', 500, function(){
                $('#attend-status').html("<h3 align='center'>Attending Session...</h3>").show('fade', 500);
                setTimeout(function(){
                    var attendReqLoc  = _server.serverLocation+"scripts/m/attend-request-n.py";
                    var attendRequest = $.ajax({
                        url:attendReqLoc, data:{st:'"""+str(studentID)+"""' , se:'"""+str(currentSessionID)+"""' }
                    });

                    attendRequest.done(function(data){
                        //alert(data);
                        $('#attend-status').html("<h3 align='center'>Request successfully sent!</h3>");
                    });
                }, 500);
            });
        });

        $('#back-button').click(function(){
            _pageHandler.generate_subject_info_page();
            //alert();
        });

    });
    </script>
    <div class='ui-bar-c' style='padding:0% 0% 0% 10%;margin:-6% 0% 5% -10%;width:105%;'>
      <h2 align='center' style='margin-left:-10px'> Attend Session </h2>
           <div style='font-weight:normal;font-size:80%;'>
             <div class='ui-grid-b'>
                <div class='ui-block-a'><strong> Subject Code:</strong> </div>
                <div class='ui-block-b'> """+sectionInfo[1]+"""("""+sectionInfo[2]+""")</div>
             </div>
             <div class='ui-grid-b'>
                <div class='ui-block-a'><strong> Schedule:</strong> </div>
                <div class='ui-block-b' style='width:50%'> 
                """+sectionInfo[4]+""" ("""+sectionInfo[5]+""") </div>
             </div>
             <div class='ui-grid-b'>
                <div class='ui-block-a'><strong> Last Session Attended:</strong></div>
                <div class='ui-block-b'>"""+last_attended+"""</div>
             </div><br />
             <div style='margin-left:-10px;'>
    """;
    
    if (hasSession):
        
        #Check if Have Attended
        arg1 = "SELECT have_attended(%s, %s)"; arg2 = (studentID, currentSessionID,)
        curr.execute(arg1, arg2); data = curr.fetchall(); have_attended = data[0][0];

        if (have_attended):
            arg1 = "SELECT is_confirmed(%s, %s)"; arg2 = (studentID, currentSessionID,)

            curr.execute(arg1, arg2); data = curr.fetchall(); isConfirmed = data[0][0]


            if (isConfirmed):
                html += """
                <h3 align='center'>
                Your session has already been confirmed. Thank you for attending your classes :)
                </h3>
                 """;
            else:
                #You are still on the waitlist...
                html += "mapa"
                html += """
                <h3 align='center'>
                You are still on your professor's attendance waitlist. Please approach your professor
                </h3>
                 """;
        else:
            html += """
                     <div id='attend-btn-cont'>
                     <button id='attend-session-btn' data-icon='check'> Attend this Session! </button>
                     </div>
                     <div id='attend-status'>
                     
                     </div>
            """
                
    else:
        html += """<h3 align='center'>There are no current ongoing sessions</h3>""";
        

    html += """ </div>
           </div><br /><br />
      </div>
    """; 


    return html;
