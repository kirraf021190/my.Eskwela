import psycopg2, string, datetime

def index(req):
    form = req.form
    name = form['d']; gradeSysID = form['g']; totalScore = form['t']; date = form['a'];

    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();

    #Do the timestamp
    now = datetime.datetime.now()
    hour = "%02d" % (now.hour,); minute = "%02d" % (now.minute,); second = "%02d" % (now.second,);
    timestamp = date + " " + hour + ":" + minute + ":" + second
    
    arg1 = "SELECT add_grade_item(%s, %s, %s, %s)"; arg2 = (name, gradeSysID, totalScore, timestamp)
    curr.execute(arg1, arg2); data = curr.fetchall(); conn.commit();

    #Get recently added grade Item ID;
    arg1 = "SELECT recent_grade_item_added(%s)"; arg2 = (gradeSysID,)
    curr.execute(arg1, arg2); data = curr.fetchall()
    
    conn.close(); curr.close()
    return data[0][0];
