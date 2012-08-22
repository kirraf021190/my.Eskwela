/*function registerUser(){
	$.post('../scripts/queries/test',function(data){	
		alert(data);
	});
}*/

function registerUser(username, password, email, firstname, middle, lastname){
	$.post('../scripts/queries/registerUser',{uname:username, pwd:password, email:email, fname:firstname, mname:middle, lname:lastname},function(data){
		alert(data);
	});
}

function changepassword(oldpass_, newpass_) {
	$.post('../scripts/queries/resetpass',{oldpass:oldpass_, newpass:newpass_},function(data){
		alert(data);
	});
}
