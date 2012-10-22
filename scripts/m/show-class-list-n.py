import psycopg2, string


def index(req):
    form = req.form
    subjectID = form['s']
    
    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();
    
    #Getting Class Information
    arg1 = "SELECT section_information(%s)"; arg2 = (subjectID, )
    curr.execute(arg1, arg2); data = curr.fetchall(); sectionInfo = string.split(data[0][0], '#')
    
    html = """
    <script>
    $(function(){
        $('.show-student-attendance').click(function(){
            var studentID = $(this).attr('id');
            
            var loc = _server.serverLocation + "scripts/m/get-attendance-report-n.py",
                section = _queryHandler.getSubjectSectionID()
            var pageRequest = $.ajax({ url:loc, data: { i:studentID, s:section } });
                pageRequest.done(function(data){
                    $('#main-pane').html(data).trigger('create');
                });
        });
    });
    </script>
    <ul data-role='listview'>
        <li> <h2> My Class List for """+sectionInfo[1]+"""("""+sectionInfo[2]+""") </h2></li>
    """;
    
    #Getting Student List
    arg1 = "SELECT enrolled_information(%s)"; curr.execute(arg1, arg2); data = curr.fetchall();
    for item in data:
        info = string.split(item[0], '#')
        html += """
            <li id='"""+info[0]+"""' class='show-student-attendance'><a href='#'>
                <img src='img/"""+info[0]+""".jpg' /> """+info[1]+"""<br />
                <span style='font-weight:normal'> """+info[0]+""" | """+info[2]+"""-"""+info[4]+"""</span>
            </a></li>
        """;
    
    return html;