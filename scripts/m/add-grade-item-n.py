import psycopg2, string


def index(req):
    form = req.form;
    description = form['d']; date = form['a']; score = form['s']; gradeID = form['g']
    
    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();
    
    #Call query...
    arg1 = "SELECT add_grade_item(%s, %s, %s, %s)"; arg2 = (description, gradeID, score, date,)
    curr.execute(arg1, arg2); data = curr.fetchall();
    
    #Close Database
    conn.close(); curr.close();
    
    return data[0][0]