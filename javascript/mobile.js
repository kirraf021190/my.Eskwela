
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
	
	serverLocation: "http://"+location.host + "/myEskwelaMobile/",
	serverPort: 80
}

var _queryHandler = {

	//Variables to be used are SessionStorage variables...
	//"Class Implementation" of the query JSON structure... 
	query: {
		queryType:null, userRole: null, userAcct: null, 
		childAcct:null, subjectSectAcct:null, reportRecipient:null
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
	setRecipientType: function(rtype){
		var queryString = sessionStorage.getItem("query"),
			query 		= jQuery.parseJSON(queryString);
			
		query.reportRecipient = rtype;
		var queryData = JSON.stringify(query); sessionStorage.setItem("query", queryData);
	},
	getRecipientType: function(){
		var queryString = sessionStorage.getItem("query"),
			query 		= jQuery.parseJSON(queryString);
			
		return query.reportRecipient;
	},
	
	getQueryType: function(){
		var queryString = sessionStorage.getItem("query"),
			query 		= jQuery.parseJSON(queryString);
			
		return query.queryType
	},
	getSubjectSectionID: function(){
		var queryString = sessionStorage.getItem("query"),
			query 		= jQuery.parseJSON(queryString);
			
		return query.subjectSectAcct;
	},
	getChildAcctID: function(){
		var queryString = sessionStorage.getItem("query"),
			query 		= jQuery.parseJSON(queryString);
			
		return query.childAcct;
	},	
	
	//Actions on Query...
	doQuery: function(subjectSectionCode){
		//DOCTYPE: Executes a mobile query, given the query values in the queryHandler
		
		alert(subjectSectionCode);
		//Store SubjectSectionCode on the Query Type		
		this.setSubjSectionID(subjectSectionCode);
		this.setChildAcctID(_sessionHandler.getAcctID());
		
		var queryType = this.getQueryType()
		if (queryType == "view-attendance"){
			$.mobile.changePage('student-attendance-viewer.html', {transition:'flip'});
		}
	},
	doQuerySetChild: function(){
		
		
		$.mobile.changePage('select-subject.html', {transition:'flip'});
	}
	
}

var _sessionHandler = {

	logoutAction: function(){
		// Remove Session Variable and Handler...
		sessionStorage.removeItem("session");
		sessionStorage.removeItem("username"); //TODO: add this to sessionHandler
		
		// Redirect to Login Page
		$.mobile.changePage('auth.html', {transition:'flip'});		
	},
	loginAction: function(loginData){
		//loginData is a JSON file...
		
		var loginDataString = JSON.stringify(loginData);
		sessionStorage.setItem("session", loginDataString);
	},
	
	// Getters
	getSessionID: function(){
		var queryString = sessionStorage.getItem("session"),
			 query 		 = jQuery.parseJSON(queryString);
			 
		return query.sessionID;	 
	},
	getUserRole: function(){
		var queryString = sessionStorage.getItem("session"),
			 query 		 = jQuery.parseJSON(queryString);
			 
		return query.userRole;	 	
	},
	getAcctID: function(){
		var queryString = sessionStorage.getItem("session"),
			 query 		 = jQuery.parseJSON(queryString);
			 
		return query.userID;
	},
        getUserName: function(){
	    var queryString = sessionStorage.getItem("session"),
                query = jQuery.parseJSON(queryString);
   
            return query.username;
        },
	
	/* Logout Action */
	logoutAction: function(){$.mobile.page.prototype.options.degradeInputs.date = true;
		//Erase all SESSION
		sessionStorage.removeItem("session");
		sessionStorage.removeItem("query");
		
		//Redirect to Login Page
		$.mobile.changePage('../auth.html', {transition:'flip'})	
	}


}


/*** All Actions are already been binded... ***/
$(document).bind('pageinit', function(e){
	/*** Override. Select Menus Fancy ***/
	$.mobile.selectmenu.prototype.options.nativeMenu = false;

	/*** Override. jQuery Mobile Opacity ***/
	$('div[data-role="dialog"]').live('pagebeforeshow', function(e, ui) {
		ui.prevPage.addClass("ui-dialog-background ");
	});

	$('div[data-role="dialog"]').live('pagehide', function(e, ui) {
		$(".ui-dialog-background ").removeClass("ui-dialog-background ");
	});
	
	/** This is for the LOGIN BUTTON on the LOGIN PAGE **/
	$('#login-btn').click(function(){
		
		function disable_all_fcns(){
			//Get Reply and check if authenticated...
			$('#login-btn-container .ui-btn-text').html("Login to my.Eskwela!");
			$('#login-username-fld').removeAttr('disabled'); $('#login-password-fld').removeAttr('disabled');
		}
	
	
		//Disable this and change to loggin in...
		$('#login-btn-container .ui-btn-text').html("Logging In...");
		$('#login-username-fld').attr('disabled', 'disabled'); $('#login-password-fld').attr('disabled', 'disabled');
		
		//Get Username and Password and send it to AJAX...
		var _username = $('#login-username-fld').val(), _password = $('#login-password-fld').val();
		
		var _location = _server.serverLocation + "scripts/m/auth.py",
			_request = $.ajax({
				url: _location, data :{
					username: _username, password:_password	
				}
			}
		);
		
		//alert(_location);
		
		_request.fail(function(){
			$.mobile.changePage('dialog_html/network-error.html', {transition:'flip', role:'dialog'});
			disable_all_fcns();
		});
		_request.done(function(data){
			//Parse JSON String
			var json = jQuery.parseJSON(data);
			//Check if Authenticated...
			if (json.status == "valid"){
				//Then if authenticated, do a store and a redirection
				_sessionHandler.loginAction(json);
				//HACK: Add username in the session...
				//sessionStorage.setItem("username", _username);			
				$.mobile.changePage('index.html', {transition:'flip'});
			} else {
				//Otherwise, Show an error...
				$.mobile.changePage('dialog_html/auth-error.html', {transition:'flip', role:'dialog'});
			}
			
			disable_all_fcns();
		});
		
	});
	
	/** This is for Main Menu Buttons **/
	$('#stats-btn').click(function(){
		//_queryHandler.initializeQuery(); 
		//_queryHandler.setQueryType("view-attendance");
		
		//Check userRole
		var userRole = _sessionHandler.getUserRole();
		alert("foo");
		if (userRole == "STUDENT"){
			//$.mobile.changePage("select-subject.html", {reloadPage:true});
		} else if (userRole == "PARENT"){
			//$.mobile.changePage("select-child.html");
		} else { alert("No can't do."); } //Impossible.
		
	});

});

//'Stats' Module Functions
var _statsMod = {
	
	openSubjectInfo: function(subjectInfo){
		//Add to QuerySessionhandler
		_queryHandler.setSubjSectionID(subjectInfo);
		
		var location = _server.serverLocation + "html_mobile/subj-stats-main.html";
		$.mobile.changePage(location, {transition:'flip'});
	}, 
	viewStudentAttendanceAsFaculty: function(studentID){
		//Add to queryHandler...
		_queryHandler.setChildAcctID(studentID);
		
		var location = _server.serverLocation + "html_mobile/view-student-attendance-as-faculty.html";
		$.mobile.changePage(location, {transition:'flip'});
	},
	//To be used on redirection for child...
	redirectToSubjectListAsParent: function(childID){
		//Add to queryHandler...
		_queryHandler.initializeQuery(); _queryHandler.setChildAcctID(childID);
		
		//var loc = _server.serverLocation + "html_mobile/subject-list-as-parent.html";
		//$.mobile.changePage(loc, {transition:'flip'});
		
		//Copied from subject-list-as-parent...
					var userRole = "STUDENT" , acctID = _queryHandler.getChildAcctID();	
				
					var _location = _server.serverLocation + "scripts/m/get-stat-main-info.py";
					var request = $.ajax({
						url: _location, data: { role:userRole, acct: acctID }
					});
					
					request.fail(function(){ 
						$.mobile.changePage('dialog_html/network-error.html', 
							{transition:'flip', role:'dialog'});
					});
					request.done(function(data){
					/*
						var ul = $(data);
						$('#stats-main-cont').append(ul);
						ul.listview();
					*/
						$('#stats-main-cont').html(data).trigger('create');
					});			
	}
		
}

//Animation and Page Module Functions...
var _pageHandler = {
	
    mainContainerHolder: $('#main-pane'),
    
	animateInType: null, animateOutType: null, 
	args: {direction:'up'}, animateSpeed:0,
	
	generate_main_page: function(container){
		/*** Main Page Content Generator ***/
		container.hide(_pageHandler.animateOutType, _pageHandler.args, _pageHandler.animateSpeed);
		setTimeout(function(){
			var pageLoc = _server.serverLocation+"html_mobile/components/home.html",
				pageContent = $.ajax({ url:pageLoc, cache:false });
			
			pageContent.done(function(data){
				container.html(data).trigger('create').show(_pageHandler.animateInType, _pageHandler.args, _pageHandler.animateSpeed);
			});	
		
		}, _pageHandler.animateSpeed);
	},
	generate_stats_page: function(container){
		/*** Page Generator after clicking "stats" button ***/
		container.hide(_pageHandler.animateOutType, _pageHandler.args, _pageHandler.animateSpeed);
		setTimeout(function(){
			var pageLoc = _server.serverLocation, 
		            role = "STUDENT";
			
			if (role == "STUDENT" || role == "FACULTY"){
				pageLoc += "html_mobile/components/subj-list.html"
			} else if (role == "PARENT"){
			        alert();
				pageLoc += "html_mobile/components/child-list.html"
			} else { alert("Can't do!"); } //Impossible.. Can't do..
			
			var pageContent = $.ajax({ url:pageLoc, cache:false });
			
			pageContent.done(function(data){
				container.html(data).trigger('create').show(_pageHandler.animateInType, _pageHandler.args, _pageHandler.animateSpeed);
			});	
		}, _pageHandler.animateSpeed);
	},
    generate_subject_info_page: function(){
        var pageLoc = _server.serverLocation + "scripts/m/get-subject-info-n.py";
        var role = _sessionHandler.getUserRole(), ssid = _queryHandler.getSubjectSectionID();
        var pageRequest = $.ajax({ url:pageLoc, data:{userRole:role, ss:ssid} });

        pageRequest.done(function(data){
            $('#main-pane').html(data).trigger('create');
        });
    },
    generate_my_attendance_results: function(){
        var pageLoc = _server.serverLocation + "scripts/m/get-attendance-report-n.py";
        var role = _sessionHandler.getUserRole(), 
        	id = null, section = _queryHandler.getSubjectSectionID();
        if (role == "PARENT"){ //Grab data from ChildList
        	
        } else { id = _sessionHandler.getAcctID(); }
        
        var pageRequest = $.ajax({ url:pageLoc, data: { i:id, s:section } });
        pageRequest.done(function(data){
            $('#main-pane').html(data).trigger('create');
        });
    },
    generate_my_grade_results: function(){
		var pageLoc = _server.serverLocation + "scripts/m/get-grade-results-n.py";
		var role = _sessionHandler.getUserRole(), 
        	id = null, section = _queryHandler.getSubjectSectionID();
        if (role == "PARENT"){ //Grab data from ChildList
        	//_queryHandler.
        } else { id = _sessionHandler.getAcctID(); }
	
		var pageReq = $.ajax({ url:pageLoc, data:{ i:id, s:section } });
		pageReq.done(function(data){
	    	$('#main-pane').html(data).trigger('create');
		});
    },
    attend_session: function(data){
		var loc = _server.serverLocation+"scripts/m/attend-session-n.py";
		var studentID =  _sessionHandler.getAcctID(), sectionID = _queryHandler.getSubjectSectionID();
		var pageReq = $.ajax({ url:loc, data:{st:studentID, se:sectionID} });

		pageReq.done(function(data){
	    	$('#main-pane').html(data).trigger('create');
        });
    },
    show_grade_list: function(){
        var loc = _server.serverLocation+"scripts/m/show-grade-list-n.py";
        var section = _queryHandler.getSubjectSectionID();

		var pageReq = $.ajax({ url:loc, data:{s:section} });
		pageReq.done(function(data){
	    	$('#main-pane').html(data).trigger('create');
        });
    },
    show_class_list: function(){
        var loc = _server.serverLocation+"scripts/m/show-class-list-n.py";
        var section = _queryHandler.getSubjectSectionID();
		var pageReq = $.ajax({ url:loc, data:{s:section} });

		pageReq.done(function(data){
	    	$('#main-pane').html(data).trigger('create');
        });
    },
    generate_child_page: function(){
        var loc = _server.serverLocation + "scripts/m/show-child-list-n.py";
        var idNum = _sessionHandler.getAcctID();
        var pageReq = $.ajax({ url:loc, data:{ id:idNum } });

        pageReq.done(function(data){
	    	$('#main-pane').html(data).trigger('create');
        });
    },
    generate_my_subjects: function(){
        var pageLoc = _server.serverLocation+"scripts/m/get-subject-list-n.py", 
            idNum = null, role = _sessionHandler.getUserRole(); 
		
		if (role == "PARENT"){
			idNum = _queryHandler.getChildAcctID(); //The Selected Child ID Acct
        } else { idNum = _sessionHandler.getAcctID(); }

		var pageReq = $.ajax({ url:pageLoc, data:{ acct:idNum, acctRole:role } });
        pageReq.done(function(data){
            $('#main-pane').html(data).trigger('create');
        });
    },
    show_add_grade_item_form: function(){
		var pageLoc = _server.serverLocation+"scripts/m/add-grade-form-n.py";
		var section = _queryHandler.getSubjectSectionID();
        var pageReq = $.ajax({ url:pageLoc, data:{s:section} });

        pageReq.done(function(data){ $('#main-pane').html(data).trigger('create'); });
    },
    show_attendance_waitlist: function(){
    	var pageLoc = _server.serverLocation+"scripts/m/show-waitlist-n.py";
		var section = _queryHandler.getSubjectSectionID();
        var pageReq = $.ajax({ url:pageLoc, data:{s:section} });

        pageReq.done(function(data){ $('#main-pane').html(data).trigger('create'); });
    },
    generate_about_page: function(){
    	var pageLoc = _server.serverLocation+"html_mobile/components/about.html",
			pageContent = $.ajax({ url:pageLoc, cache:false });
			
		pageContent.done(function(data){
			$('#main-pane').html(data).trigger('create').show(_pageHandler.animateInType, _pageHandler.args, _pageHandler.animateSpeed);
		});	
    },
    generate_settings_page: function(){
    	var pageLoc = _server.serverLocation+"html_mobile/components/settings.html",
			 pageContent = $.ajax({ url:pageLoc, cache:false });
			
		pageContent.done(function(data){
			$('#main-pane').html(data).trigger('create').show(_pageHandler.animateInType, _pageHandler.args, _pageHandler.animateSpeed);
		});	
    }
}

//Attendance Report
