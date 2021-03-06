import psycopg2, string


def index(req):
    form = req.form
    subjectID = form['s']
    gradeItem = form['i']
    
    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();
    
    #Getting information on grade item
    arg1 = "SELECT grade_item_information(%s)"; arg2 = (gradeItem,)
    curr.execute(arg1, arg2); data = curr.fetchall(); gradeItemInfo = string.split(data[0][0], '#') 
    
    
    html = """
<script>
$(function(){
    $('#back-to-list-btn').click(function(){
        _pageHandler.show_grade_list();
    });
    
    $('#save-list-btn').click(function(){
        $('#button-list').hide('slide', 500, function(){
            $('#loading-list').show('slide', 500);
            
            setTimeout(function(){
                
                $('#item-entry-list li').each(function(){
                    //alert($(this).attr('id'));
                    var item_entry_id = $(this).attr('id'),
                        score = $('#grade'+item_entry_id+'').val(),
                        studentID = $('#idnum'+item_entry_id+'').html();

                    var grade_item = """+gradeItemInfo[0]+""";
                    
                    //alert("Item Entry ID is: "+item_entry_id)
                    //alert("Score is: "+score+" and studentID is: "+studentID);
                    var loc = _server.serverLocation+"scripts/m/score-edit-request.py";
                    var editRequest = $.ajax({
                        url:loc, data:{ i:grade_item, sc:score, st:studentID }
                    });
                    
                    editRequest.done(function(data){
                        //alert(data);
                    })
                });
            
                $('#loading-list').hide('slide', 500, function(){
                    $('#button-list').show('slide', 500); //_pageHandler.show_grade_list();
                    alert("Grade Records has been saved.");
                });
            }, 2000);
        });
    });
    
    $('#loading-list').hide(0);

});
</script>
 <div class='ui-bar-c' style='padding:0% 0% 0% 10%;margin:-6% 0% 5% -10%;width:105%;'>
      <h2> Student Grade List </h2>
           <div style='font-weight:normal;font-size:80%;'>
             <div class='ui-grid-b'>
                <div class='ui-block-a'><strong> Grade Item:</strong> </div>
                <div class='ui-block-b'> """+gradeItemInfo[0]+"""</div>
             </div>
             <div class='ui-grid-b'>
                <div class='ui-block-a'><strong> Description:</strong> </div>
                <div class='ui-block-b'> """+gradeItemInfo[1]+"""</div>
             </div>
             <div class='ui-grid-b'>
                <div class='ui-block-a'><strong> Date:</strong> </div>
                <div class='ui-block-b' style='width:50%'> """+gradeItemInfo[3]+"""</div>
             </div>
             <div class='ui-grid-b'>
                <div class='ui-block-a'><strong> Perfect Score:</strong> </div>
                <div class='ui-block-b'> """+gradeItemInfo[2]+"""</div>
             </div>
           </div><br />
           <div id='button-list' class='ui-grid-a' style='margin-left:-5px;'>
               <div class='ui-block-a'>
                   <button id='save-list-btn'>Save</button>
               </div>
               <div class='ui-block-b'>
                   <button id='back-to-list-btn'>Back</button>
               </div>
           </div>
           <div id='loading-list' align='center'><img src='img/load.gif' /><br />Saving Records...</div>
      </div>
      <div style='overflow-y:auto;padding:15px;margin:-15px;height:165px;'>
          <ul id='item-entry-list' data-role='listview' data-filter='true'> """;
          
    #Get all list of enrolled students, with grades...
    #listofStudents = []
    #arg1 = "SELECT enrolled_information(%s)"; arg2 = (subjectID,)
    #curr.execute(arg1, arg2); data = curr.fetchall();
    
    #for s in data:
    #    studentInfo = string.split(s[0], '#');
        #Get their respective grades
    #    ar1 = "SELECT get_grade_item_entry(%s)"
        
    #    student = [studentInfo, 0]
    #    listofStudents.append(student)
     
    arg1 = "SELECT get_grade_item_entry_information(%s)"; arg2 = (gradeItem,)
    curr.execute(arg1, arg2); listofStudents = curr.fetchall();   
    
    #Printing them...
    for students in listofStudents:
        
        student = string.split(students[0], '#') 
        html += """
              <li id='"""+student[0]+"""' >
                  <div class='ui-grid-a'>
                      <div class='ui-block-a' style='width:50%'>
                        """+student[2]+"""<br />
                        <span id='idnum"""+student[0]+"""'>"""+student[1]+"""</span>
                      </div>
                      <div class='ui-block-b'>
                          <input type='number' id='grade"""+student[0]+"""' data-mini='true' value='"""+student[3]+"""' size=2 style='width:30%;float:right;' />
                      </div>
                  </div>
              </li>
        """;
        
        
    html += """
        </ul>
    </div>
    
    """
    
    
    return html;
