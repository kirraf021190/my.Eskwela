import psycopg2, string, datetime


def index(req):
    form = req.form
    sessionID = form['se']; studentID = form['st']

    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();

    #Get Current Date and Time
    now = datetime.datetime.now()
    currentDate = str(now.year)+"-"+str(now.month)+"-"+str(now.day)

    arg1 = "SELECT add_attendance_by_phone(%s, %s, %s)"; arg2 = (sessionID, studentID, currentDate);
    curr.execute(arg1, arg2); data = curr.fetchall(); conn.commit();

    conn.close(); curr.close()
    return data[0][0];
    
