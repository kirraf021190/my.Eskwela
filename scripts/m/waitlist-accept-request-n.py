import psycopg2, string, datetime


def index(req):
    form = req.form
    student = form['i']; session = form['s']

    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();

    arg1 = "SELECT confirm_attendance(%s, %s)"; arg2 = (session, student);
    curr.execute(arg1, arg2); data = curr.fetchall(); conn.commit();

    conn.close(); curr.close()
    return data[0][0];
    
