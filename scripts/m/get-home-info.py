import pg, string


def index(req):
    form = req.form
    username = form['acctID']
    uname = form['uname']

    db = pg.connect('myEskwela', 'localhost', 5432, None, None, 'postgres', 'password')
    q0 = "SELECT student_information('"+username+"')"
    query = db.query(q0)
    result = query.dictresult()

    info = string.split(result[0]['student_information'], '#')
    name = info[2]+", "+info[0]+" "+info[1]


    
    return """
        <div id='main-menu-basic-info-cont' align='center'>
				<img src='img/nopic.jpg' />
				<div id='basic-info-content'>
					<h2>"""+name+"""</h2>	
				</div>				
			</div>
			<div id='main-menu-adv-info'>
				<div class='ui-grid-a'>
					<div class='ui-block-a'>Account Type:</div>
					<div class='ui-block-b'>Student</div>
				</div>
				<div class='ui-grid-a'>
					<div class='ui-block-a'>ID Number:</div>
					<div class='ui-block-b'>"""+username+"""</div>
				</div>
				<div class='ui-grid-a'>
					<div class='ui-block-a'>Username:</div>
					<div class='ui-block-b'>"""+uname+"""</div>
				</div>
				<div class='ui-grid-a'>
					<div class='ui-block-a'>Last Login:</div>
					<div class='ui-block-b'>12/21/2012 23:59:59</div>
				</div>
			</div>


        """
