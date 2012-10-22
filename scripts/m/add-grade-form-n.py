import psycopg2, string

#var loc = _server.serverLocation + "scripts/m/student-grade-list-n.py";
#var loc0 = _server.serverLocation + "scripts/m/add-grade-item-n.py";

def index(req):
    form = req.form
    sectionID = form['s']
    
     #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();

    html = """
    <script>
    $(function(){
       $('#back-to-grades-btn').click(function(){
           _pageHandler.show_grade_list();
       });

        $('#add-grade-item-btn').click(function(){
            //INIT VARS
            var description = $('#description').val(),
                gradeItem   = $('#grade-item').val(),
                totalScore  = $('#total-score').val(),
                date        = $('#date').val();

            if (description == ""){ alert("Please enter description"); }
            else if (gradeItem == "Select Grading Item"){
                alert("Please select a grading item.");
            } else if (totalScore <= 0){
                alert("Please enter the highest possible score (not less than 0)");
            } else if (date == ""){ alert("Please enter the date."); }
            else {
                //Send Add Request...
                var loc = _server.serverLocation + "scripts/m/add-grade-item-request-n.py";
                var addRequest = $.ajax({ url:loc, 
                    data:{d:description, g:gradeItem, t:totalScore, a:date}  });

                addRequest.done(function(data){
                    alert("Grade Item has been successfully added!");
                    //_pageHandler.show_grade_list();
                    
                     var loc = _server.serverLocation + "scripts/m/student-grade-list-n.py";
                     var subj = _queryHandler.getSubjectSectionID(); 
                     var id = data; //alert(id);
                     var pageRequest = $.ajax({ url:loc, data:{ s:subj, i:id } }); 
               
                     pageRequest.done(function(data){
                        $('#main-pane').html(data).trigger('create');
                     });
                });
            }
        });
    });
    </script>
    <div class='ui-bar-c' style='padding:0% 0% 0% 10%;margin:-6% 0% 5% -10%;width:105%;'>
        <h2 align='center' style='margin-left:-20px;'> Add New Grade Item </h2>
        <div id='add-grade-form-cont' style='margin-left:-5px;width:95%;'>
            Description:
            <input type='text' id='description' placeholder='Description' />
            Grading Item:
            <select id='grade-item'>
                <option>Select Grading Item</option> """;


    #Getting grading systems...
    arg1 = "SELECT get_grading_system_information(%s)";arg2 = (sectionID,)
    curr.execute(arg1, arg2); data = curr.fetchall();
    
    for info in data:
        grading = string.split(info[0], '#')
        html += """           
                <option value='"""+grading[0]+"""'> """+grading[1]+""" ("""+grading[2]+""" %) </option>
        """;
                
    html += """
            </select>
            Total Possible Score:
            <input type='number' id='total-score' placeholder='Total Possible Score' />
            Date:
            <input type='text' id='date' placeholder='YYYY-MM-DD' />
            <div style='margin-top:20px'>
                <button id='add-grade-item-btn'>Add Grade Item </button>
                <button id='back-to-grades-btn'>Back to Grades </button>
            </div>
        </div>
    </div>

    """;
    
    conn.close(); curr.close();
    return html;
