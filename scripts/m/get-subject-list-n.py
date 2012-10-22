#from myEskwela import *
import psycopg2, string

def index(req):
    form = req.form; 
    acctID = form['acct'];
    acctRole = form['acctRole']; 
 
    html = """
        <script>
        $(function(){
            $('.subject-list-item').click(function(){
	    	    var subjSectID = $(this).attr('id');
		
        		//Initiate and append to QueryHandler
	        	_queryHandler.initializeQuery();
	        	_queryHandler.setSubjSectionID(subjSectID);
		
        		//Set Back Tracker...
        """;

    #if (acctRole == "PARENT"):
    #    html += """
    #        $('#back-button').click(function(){
    #            alert();
    #        });
    #    """
    #else:
    #    html += """
    #            $('#back-button-cont').hide(0);
    #    """;
        
    html += """	
        		//Go to Subject Info...
        		_queryHandler.setSubjSectionID(subjSectID);
                _pageHandler.generate_subject_info_page();
                
                $('#back-button-cont').hide(0);
        	});
        });
        </script>
        <ul data-role='listview'>
            <li> Current Subject(s) List as of current SY</li>
            <li data-role='list-divider'> Please select from below: </li>
    """;
    #print "Here goes the war\n";
    
    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();

    #Get Current Term..
    arg1 = "SELECT current_term()"; curr.execute(arg1);
    data = curr.fetchone(); currentTerm = data[0];

    #Getting the List of SubjectSection(s)    arg1 = None; arg2 = "";
    if (acctRole == "STUDENT" or acctRole == "PARENT"):
        arg1 = "SELECT student_load_information(%s, %s)"; arg2 = (acctID, currentTerm,);
    elif (acctRole == "FACULTY"):
        arg1 = "SELECT faculty_load_information(%s, %s)"; arg2 = (acctID, currentTerm);
    
    curr.execute(arg1, arg2); data = curr.fetchall();
    for load in data:
        info = string.split(load[0], '#');
        html += "<li id='"+info[0]+"' class='subject-list-item'><a href='#'>";
        html += info[1]+"("+info[2]+")<div style='font-size:80%;font-weight:normal'>";
        html += info[3]+"</div></a></li>";

            #<li id='TEST1' class='subject-list-item'><a href='#'> foo</a></li>
            #<li id='TEST2' class='subject-list-item'><a href='#'> foo</a></li>
            #<li id='TEST3' class='subject-list-item'><a href='#'> foo</a></li>

 #   html += """ </ul> """;

    #Closing Database Connection(s)
    curr.close(); conn.close();
    
    #Return Final HTML DOM
    return html;
