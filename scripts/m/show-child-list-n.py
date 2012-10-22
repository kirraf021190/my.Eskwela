import psycopg2, string

def index(req):
    form = req.form
    
    idNumber = form['id'] #'P-2373'

    html = """
    <script>
    $(function(){
        $('.select-child-btn').click(function(){
            var childID = $(this).attr("id");

            //Show Back button and redirect to 
            //alert(childID);
            _queryHandler.initializeQuery();
            _queryHandler.setChildAcctID(childID);
            _pageHandler.generate_my_subjects();
        });
    });
    </script>
    <ul data-role='listview'>
        <li> <h2> Please select from your child </h2></li>
    """;
    
    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();
    
    # Getting list of children...
    arg1 = "SELECT get_children_information(%s)"; arg2 = (idNumber, )
    curr.execute(arg1, arg2); data = curr.fetchall();
    
    for child in data:
        childInfo = string.split(child[0], '#')
        html += """
            <li id='"""+childInfo[0]+"""' class='select-child-btn'><a href='#'>
            <img src='img/"""+childInfo[0]+""".jpg' />
             <!--   """+childInfo[3]+""", """+childInfo[1]+""" """+childInfo[2]+""" -->
                """+childInfo[1]+"""
                <br />
               <span style='font-weight:normal'>"""+childInfo[0]+""" | """+childInfo[4]+"""</span>
            </a></li>
        """;
    
    
    #    <li id='2009-0661' class='select-child-btn'><a href='#'><img src='img/nopic.jpg' />
    #   Bandiola, Kieth Mark S.<br />
    ##    <span style='font-weight:normal'>2009-0661 | BSCS-4</span>
    #    </a> </li>
    #    <li id='2010-1010' class='select-child-btn'><a href='#'><img src='img/nopic.jpg' />
    #    Bandiola, Kieth Mark S.<br />
    #    <span style='font-weight:normal'>2009-0661 | BSCS-4</span>
    #    </a> </li>

    html += """
    </ul>
    """;

    return html;
