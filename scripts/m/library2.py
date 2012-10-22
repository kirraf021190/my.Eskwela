
import psycopg2

class Database:

    self.cursor = None;

    def __init__(self):
        con = psycopg2.connect(database='myEskwela', user='postgres', password='password', host='localhost', port=5432)
        self.cursor = con.cursor();

    def close(self):
        self.cursor.close()



class 
