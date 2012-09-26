import pg, string


def index(req):
    form = req.form
    rtype = form['r']

    #Connect to Database
    db = pg.connect('myEskwela', 'localhost', 5432, None, None, 'postgres', 'password')

    msg = "<div align='center'><h4>Stats sent succesfully ";
    if (rtype == "EMAIL"):
        msg += "to your email at:</h4> <i>kiethmark.bandiola@g.msuiit.edu.ph</i>"
    elif(rtype == "SMS"):
        msg += "via SMS at your phone number:</h4> <i>0905-717-7249</i>"
    
    msg += "<a href='#' data-rel='back' data-role='button'>OK</a></div>"

    return '{"sent":"true", "msg":"'+msg+'"}'

