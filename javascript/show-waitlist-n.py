import psycopg2, string

def index(req):
    
    form = req.form; section = form['s']
    
    #Connect to Database, currently, i'm doing a hardline... 
    connString = "dbname=myEskwela user=postgres password=password host=localhost port=5432"
    conn = psycopg2.connect(connString); curr = conn.cursor();
    
    #Get subject information
    
    #Get ongoing session.. and its information
    
    #Get list of on 
    
    
    html = """
    
    
    """;
    
    return html;