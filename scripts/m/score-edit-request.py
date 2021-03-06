import psycopg2, string


def index(req):
    form = req.form;
    item_entry_id = form['i']; score = form['sc']; studentID = form['st']
    
    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();
    
    #Call query...
    arg1 = "SELECT add_grade_item_entry(%s, %s, %s)"; arg2 = (item_entry_id, score, studentID,)
    curr.execute(arg1, arg2); data = curr.fetchall(); conn.commit();
    
    #Close Database
    conn.close(); curr.close();
    
    return data[0][0];
    
