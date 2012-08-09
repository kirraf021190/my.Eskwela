/****
my.Eskwela Main JavaScript Library
by: kiethmark bandiola
7/21/2012
****/

//	JSON Stringify Function
//	Source from: http://stackoverflow.com/questions/3593046/jquery-json-to-string
JSON.stringify = JSON.stringify || function (obj) {
    var t = typeof (obj);
    if (t != "object" || obj === null) {
        // simple data type
        if (t == "string") obj = '"'+obj+'"';
        return String(obj);
    }
    else {
        // recurse array or object
        var n, v, json = [], arr = (obj && obj.constructor == Array);
        for (n in obj) {
            v = obj[n]; t = typeof(v);
            if (t == "string") v = '"'+v+'"';
            else if (t == "object" && v !== null) v = JSON.stringify(v);
            json.push((arr ? "" : '"' + n + '":') + String(v));
        }
        return (arr ? "[" : "{") + String(json) + (arr ? "]" : "}");
    }
};

//Here implements the GLOBAL Variables...
//These must not be declared again in other JS Files

var _server = {
	
	serverLocation: "http://localhost/eskwela.iit.edu.ph/s/",
	serverPort: 80
}

var _sessionHandler = {

	session: {
		currentUserAcctID: null, currentUserRole: null
	},

	initateSessionHandler: function(){
		
	},
	
	deleteSessionHandler: function(){
		//Clear 
	}
}

var _queryHandler = {

	//Variables to be used are SessionStorage variables...
	//"Class Implementation" of the query JSON structure... 
	query: {
		queryType:null, userRole: null, userAcct: null, 
		childAcct:null, subjectSectAcct:null
	},
	
	//Methods are found here... 
	initializeQuery: function(){
		/*** DOCTYPE: This is only used in Main Menu Page... ***/
		
		var _query = this.query;
		//Get User Acct ID and Role. Get them in SessionUser Structure..
		_query.userRole = null; _query.userAcct = null;
		
		//Bring back to data structure and store to sessionStorage
		var queryData = JSON.stringify(_query); sessionStorage.setItem("query", queryData);
	},
	setQueryType: function(_queryType){
		/*** DOCTYPE: Used in Clicking Hyperlinks in Main Menu... ***/
		var queryString = sessionStorage.getItem("query"),
			query 		= jQuery.parseJSON(queryString);
			
		query.queryType = _queryType;
		var queryData = JSON.stringify(query); sessionStorage.setItem("query", queryData);
	},

	//Actions for Student and Parent
	setChildAcctID: function(_acctID){
		/*** DOCTYPE: Used for selecting child student from child roster 
				Precondition: _role is PARENT, and actor have selected a child from the roster..
		***/
		
		var queryString = sessionStorage.getItem("query"),
			query 		= jQuery.parseJSON(queryString);
			
		query.childAcct = _acctID;
		var queryData = JSON.stringify(query); sessionStorage.setItem("query", queryData);
	},
	setSubjSectionID: function(_SSID){
		/*** DOCTYPE: Used for selecting child student from child roster 
				Precondition: _role is PARENT, and actor have selected a child from the roster..
		***/
		
		var queryString = sessionStorage.getItem("query"),
			query 		= jQuery.parseJSON(queryString);
			
		query.subjectSectAcct = _SSID;
		var queryData = JSON.stringify(query); sessionStorage.setItem("query", queryData);
	},
	
}

var _authHandler = {

	logoutAction: function(){
		// Get Session Handler...
		
		// Remove Session Variable and Handler...
		
		// Redirect to Login Page
		
	},
	loginAction: function(acctNumber, sessionID){
		
	}


}

var _UIHandler = {

	//Print
	
	showErrorMessage: function(msgHeader, msgBody){
		/*** Calls the error message template ***/
		
	}

}


//Authentication Class...
function Auth(user, pass){
	
	this.username = user;
	this.password = pass;
	
	this.authenticate = function(){
		var result = false, location = _serverLocation + "auth/auth.php";
		var request = $.ajax({
			url:location, type:"POST",
			data:{ username:this.username, password:this.password }
		});
		
		//AfterMath
		request.done(function(data){
			if (data == "true"){ 
				return true; 
			} else { return false; }
		}); request.fail(function(){ return "FAIL_REQUEST"; }); //FAIL_REQUEST constant...
	}
	
	this.logout = function(){
		//This function will just execute for logging out purposes...
		//Can be called using new Auth(null, null);
		sessionStorage.removeItem('myEskwela');
	}

}



