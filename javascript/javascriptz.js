function getStudInfo() {
  getClasses()
  $.post('../scripts/queries/getInfo',function(data){
  if(data.length>0){
          info = data.split(",")
          var table = document.getElementById('userinfo') 
          table.rows[1].cells[1].innerHTML = info[0]
          table.rows[2].cells[1].innerHTML = info[1]
          table.rows[3].cells[1].innerHTML = info[2]
          table.rows[4].cells[1].innerHTML = info[3]
       }
	});
}

function getFacInfo() {
  getFacClasses()
  $.post('../scripts/queries/getInfo',function(data){
  if(data.length>0){
          info = data.split("#")
          var table = document.getElementById('userinfo') 
          table.rows[1].cells[1].innerHTML = info[1]
          table.rows[2].cells[1].innerHTML = info[0]
          table.rows[3].cells[1].innerHTML = info[2]
          table.rows[4].cells[1].innerHTML = info[3]
       }
	});
	
}
function getClasses(){
    $.post('../scripts/queries/getClasses',function(data){
       if(data.length>0){
          classes = data.split("@")
          for(i=0; i<classes.length-1; i++){
	     details = classes[i].split("$")
	     
             var tbody = document.getElementById
	("classList").getElementsByTagName('TBODY')[0];
	var row = document.createElement('TR')
	
	var td1 = document.createElement('TD')
	td1.innerHTML = details[0];
		
	var td2 = document.createElement('TD')
	td2.innerHTML = details[1];
	
	var td3 = document.createElement('TD')
	td3.innerHTML = details[2];
		
	var td4 = document.createElement('TD')
	td4.innerHTML = details[3];
		
	var td5 = document.createElement('TD')
	td5.innerHTML = details[4];

	var td6 = document.createElement('TD')
	td6.innerHTML = details[5];

	var td7 = document.createElement('TD')
	td7.innerHTML = details[6];


	var td9 = document.createElement('TD')
	td9.innerHTML = '<script type="text/javascript" src="try1.js"></script><center><input type="button" value="View" id="view_button" onclick="location.href=\'../scripts/form/section?sec='+details[1]+'&scode='+details[7]+'\'"></center>'
	
	var td10 = document.createElement('TD')
	td10.innerHTML = details[7];
	td10.setAttribute("style", 'display: none');
	
		
		row.appendChild(td1);
		row.appendChild(td2);
		row.appendChild(td3);
		row.appendChild(td4);
		row.appendChild(td5);
		row.appendChild(td6);
		row.appendChild(td7);
		row.appendChild(td9);
		row.appendChild(td10);
		tbody.appendChild(row);             
	  }
       }
    });
}
function getFacClasses(){
    $.post('../scripts/queries/getClasses',function(data){
       if(data.length>0){
          classes = data.split("@")
          for(i=0; i<classes.length-1; i++){
	     details = classes[i].split("#")
	     
             var tbody = document.getElementById
	("classList").getElementsByTagName('TBODY')[0];
	var row = document.createElement('TR')
	
	var td1 = document.createElement('TD')
	td1.innerHTML = details[1];
		
	var td2 = document.createElement('TD')
	td2.innerHTML = details[2];
	
	var td3 = document.createElement('TD')
	td3.innerHTML = details[3];
		
	var td4 = document.createElement('TD')
	td4.innerHTML = details[4];
		
	var td5 = document.createElement('TD')
	td5.innerHTML = details[5];

	var td6 = document.createElement('TD')
	td6.innerHTML = details[7];

	var td9 = document.createElement('TD')
	td9.innerHTML = '<center><input type="button" value="View" id="view_button" onclick="location.href=\'../scripts/form/section?sec='+details[1]+'&scode='+details[0]+'\'"></center>'
	
	var td10 = document.createElement('TD')
	td10.innerHTML = details[0];
	td10.setAttribute("style", 'display: none');
		
		row.appendChild(td1);
		row.appendChild(td2);
		row.appendChild(td3);
		row.appendChild(td4);
		row.appendChild(td5);
		row.appendChild(td6);
		row.appendChild(td9);
		row.appendChild(td10);
		tbody.appendChild(row);             
	  }
       }
    });
}
function getattend(){
$.post('../scripts/queries/getCurrentClass',function(data){
	var inputf = document.getElementById("sections");
	inputf.value = data;
});
$.post('../scripts/queries/getAttendanceBySubject',function(data){
       if(data.length>0){
          classes = data.split("@")
          for(i=0; i<classes.length-1; i++){
	     details = classes[i].split("#")
	     
             var tbody = document.getElementById
	("students_attendance").getElementsByTagName('TBODY')[0];
	var row = document.createElement('TR')
	
	var td1 = document.createElement('TD')
	td1.innerHTML = details[0];
		
	var td2 = document.createElement('TD')
	td2.innerHTML = details[1];
	
	var td3 = document.createElement('TD')
	td3.innerHTML = details[2];	
	
	var td4 = document.createElement('TD')
	td4.innerHTML = '<center><b style = "color:green">YES</b></center>';	
	
	var b = document.createElement('input')
	b.setAttribute("class" , 'confattend'); 
 	b.setAttribute("type" , 'button');
	b.setAttribute("value", 'Confirm');
	b.setAttribute("id", 'view_button');
	var cn = document.createElement('center')
	cn.appendChild(b)
	var td5 = document.createElement('TD')
	td5.appendChild(cn)
		
		row.appendChild(td1);
		row.appendChild(td2);
		row.appendChild(td3);
		
		if(details[3] == 'false')
			row.appendChild(td5);
		else
			row.appendChild(td4);
			
		tbody.appendChild(row);             
	  }
       }
    });

$.post('../scripts/queries/getCurrentSession',function(data){
	if(data == '0') {
		var div1 = document.getElementById("dvattendance");
		var b = document.createElement('input')
		b.setAttribute("class" , 'startsessionbutton');
		b.setAttribute("type" , 'button');
		b.setAttribute("value", 'Start Class');
		b.setAttribute("id", 'view_button');
		div1.appendChild(b);
	}
	else { 
		var div1 = document.getElementById("dvattendance");
		var b = document.createElement('input')
		b.setAttribute("class" , 'endsessionbutton');
		b.setAttribute("type" , 'button');
		b.setAttribute("value", 'End Class');
		b.setAttribute("id", 'view_button');
		div1.appendChild(b);
	}
		

});

getgradesystem();
getgradeitems();
//refreshtab();
}

function addAttendance(idnum){
	var isvalid = true;
	$('#attendbody tr').each(function(index){
		if(this.cells[0].innerHTML == idnum ) {
			$().toastmessage('showErrorToast', idnum + '  ' + 'already exists!');
			isvalid = false;
			return false;
		}
	});
	if(isvalid) {
		$.post('../scripts/queries/addAttendance',{idnum_:idnum},function(data){
			if(data == 'True') {
				$.post('../scripts/queries/getAttendanceBySubject',function(data){
					if(data.length>0){
          				classes = data.split("@")
	    				details = classes[0].split("#")
	     
            	 		var tbody = document.getElementById("students_attendance").getElementsByTagName('TBODY')[0];
						var row = document.createElement('TR')
	
						var td1 = document.createElement('TD')
						td1.innerHTML = details[0];
		
						var td2 = document.createElement('TD')
						td2.innerHTML = details[1];
		
						var td3 = document.createElement('TD')
						td3.innerHTML = details[2];	
					
						var b = document.createElement('input')
						b.setAttribute("class" , 'confattend'); 
 						b.setAttribute("type" , 'button');
						b.setAttribute("value", 'Confirm');
						b.setAttribute("id", 'view_button');
						var cn = document.createElement('center')
						cn.appendChild(b)
					
						var td4 = document.createElement('TD')
						td4.appendChild(cn);
						
						var td5 = document.createElement('TD')
						td5.innerHTML = '<center><b style = "color:green">YES</b></center>';
									
						row.appendChild(td1);
						row.appendChild(td2);
						row.appendChild(td3);
						row.appendChild(td5);
													
						$(tbody).prepend(row).children(':first').hide().fadeIn(1000, function() { });
						$().toastmessage('showSuccessToast', 'Attendance Logged');		
                	}
    			});
			}
			else {
				if(data == 'False')
					$().toastmessage('showErrorToast', 'Class not started');
				
				else
					$().toastmessage('showErrorToast', 'Student not found!');
			}

		});
	}
}

function getgradesystem() {
	$.post('../scripts/queries/getGradeSystem',function(data){
       if(data.length>0){
          classes = data.split("@")
          for(i=0; i<classes.length-1; i++){
	     details = classes[i].split("$")
	     
             var tbody = document.getElementById
	("users").getElementsByTagName('TBODY')[0];
	var row = document.createElement('TR')
	
	var td1 = document.createElement('TD')
	td1.innerHTML = details[0];
		
	var td2 = document.createElement('TD')
	td2.setAttribute("class" , 'edit'); 
	td2.innerHTML = details[1]

	var td3 = document.createElement('TD')
	var cn = document.createElement('center')
	var b = document.createElement('input')
	b.setAttribute("class" , 'del'); 
 	b.setAttribute("type" , 'button');
	b.setAttribute("value", 'Delete');
	b.setAttribute("id", 'view_button');
		
		row.appendChild(td1);
		row.appendChild(td2);
		cn.appendChild(b);
		td3.appendChild(cn)
		row.appendChild(td3);
		tbody.appendChild(row);             
	  }
       }
       
    });
}


function setGradeSystem(name,weight){
	
	var table = document.getElementById("users");
	var temp = 0;
	var valid = true;
	var reg = new RegExp("^[+]?[0-9]+?[0-9]+$");
	if(!reg.test(weight)) {
		$().toastmessage('showErrorToast', 'Invalid Input');
		return;
	}
	for(var i = 1; i < table.rows.length; i++) {
   		 if(table.rows[i].cells[0].innerHTML.toLowerCase() == name.toLowerCase()) {
   		 	valid = false;
   		 	$().toastmessage('showErrorToast', table.rows[i].cells[0].innerHTML + ' ' + 'already exists!');
			return;
   		 }
	}
	for(var i = 1; i < table.rows.length; i++) {
   		 temp = temp + parseInt(table.rows[i].cells[1].innerHTML);
	}
	temp = temp + parseInt(weight)
	if(temp > 100) {
		valid = false;
		$().toastmessage('showErrorToast', 'Exceeded 100%');
		return;
	}
	
	if(valid){
		$.post('../scripts/queries/setGradeSystem',{name_:name,weight_:weight},function(data){
			if(data == 'true') {
				var row = document.createElement('TR')
	
				var td1 = document.createElement('TD')
				td1.innerHTML = name;
	
		
				var td2 = document.createElement('TD')
				td2.setAttribute("class" , 'edit'); 
				td2.innerHTML = weight;
	
				var td3 = document.createElement('TD')
				var cn = document.createElement('center')
				var b = document.createElement('input')
				b.setAttribute("class" , 'del'); 
 				b.setAttribute("type" , 'button');
				b.setAttribute("value", 'Delete');
				b.setAttribute("id", 'view_button');
	
				row.appendChild(td1);
				row.appendChild(td2);
				cn.appendChild(b);
				td3.appendChild(cn)
				row.appendChild(td3);				

				if($('#gradecattablebody tr').length == 0) {
					$("#gradecattablebody").prepend(row).children(':first').hide().fadeIn(1000, function() { });
					$().toastmessage('showSuccessToast', name + '  ' + 'added');
					return;
				}
					
				$('#gradecattablebody tr').each(function(index){
					if(this.cells[1].innerHTML <= parseInt(weight) ) {
						$(this).before(row).prev().hide().fadeIn(1000, function() { });
						$().toastmessage('showSuccessToast', name + '  ' + 'added');
						return false;
					}
					if($(this).is(':last-child')) {
    					$(this).after(row).next().hide().fadeIn(1000, function() { });
						$().toastmessage('showSuccessToast', name + '  ' + 'added');
					}																		    
				})			
			}
		
		});
	}
}
function editweight(v,n){
	n.innerHTML = v
	var table = document.getElementById("users");
	var temp = 0;
	var reg = new RegExp("^[+]?[0-9]+?[0-9]+$");
	if(!reg.test(v)) {
		$().toastmessage('showErrorToast', 'Invalid Input');
		n.parentNode.childNodes[1].revert();
		return false;
	}
	for(var i = 1; i < table.rows.length; i++) {
   		 temp = temp + parseInt(table.rows[i].cells[1].innerHTML);
	}
	if(temp > 100) {
		$().toastmessage('showErrorToast', 'Exceeded 100%');
		n.parentNode.childNodes[1].revert();
	}
	else {
		$.post('../scripts/queries/editCatWeight',{name_:n.parentNode.childNodes[0].innerHTML, weight_:n.innerHTML},function(data){
			$().toastmessage('showNoticeToast', n.parentNode.childNodes[0].innerHTML + '  ' + 'updated');
			$(n).animate().hide().fadeIn(1000, function() { });
		});
	}

}

function deletecat(n){
	$.post('../scripts/queries/deleteCategory',{name_:n.childNodes[0].innerHTML},function(data){
		if(data == 'true') {
			$().toastmessage('showErrorToast', n.childNodes[0].innerHTML + '  ' + 'deleted');
			$(n).animate().fadeOut(400,function(){ 
				$(n).remove()
			});
		}

	});
}

function confirmattend(n){

	$.post('../scripts/queries/confirmAttend',{idnum_:n.childNodes[0].innerHTML,time:n.childNodes[2].innerHTML},function(data){
		if(data == 'true') {
			$().toastmessage('showSuccessToast', 'Attendance Confirmed');		
			$(n.childNodes[3].childNodes[0].childNodes[0]).animate().fadeOut(400,function() {
				$(this).remove();	
				
				var fx = document.createElement('CENTER');
				fx.innerHTML = '<b style = "color:green">YES</b>';
				$(n.childNodes[3].childNodes[0]).append(fx).animate().hide().fadeIn(1000, function(){});

			});	
		}	
	});
	
}

function refreshtab() {

	var tbody = document.getElementById("students_attendance").getElementsByTagName('TBODY')[0];
	setInterval(function(){
		$.post('../scripts/queries/getAttendanceBySubject',function(data){
			classes = data.split("@");			
			var n = classes.length - 1;
				while(n >= 0) {
					if(n - ((classes.length - 1)- $(tbody).children().size()) < 0) {
						details = classes[n].split("$")

						var row = document.createElement('TR')
	
						var td1 = document.createElement('TD')
						td1.innerHTML = details[0];
			
						var td2 = document.createElement('TD')
						td2.innerHTML = details[1];
	
						var td3 = document.createElement('TD')
						td3.innerHTML = details[2];	
	
						var td4 = document.createElement('TD')
						td4.innerHTML = '<center><b style = "color:green">YES</b></center>';	
	
						var b = document.createElement('input')
						b.setAttribute("class" , 'confattend'); 
 						b.setAttribute("type" , 'button');
						b.setAttribute("value", 'Confirm');
						b.setAttribute("id", 'view_button');
						var cn = document.createElement('center')
						cn.appendChild(b)
						var td5 = document.createElement('TD')
						td5.appendChild(cn)
		
						row.appendChild(td1);
						row.appendChild(td2);
						row.appendChild(td3);
		
						if(details[3] == 'false')
							row.appendChild(td5);
						else
							row.appendChild(td4);
			
						$(tbody).prepend(row).children(':first').hide().fadeIn(1000, function() { });
						$().toastmessage('showSuccessToast', details[1] + '  ' + 'has checked in');		
					}
					n--;
				}
				
			

		});
	},3000);


}
 
function gradecatdropdown (){
	gradecatlist = document.getElementById("period1");
	$.post('../scripts/queries/getGradeSystem',function(data){
		$(gradecatlist.childNodes).each(function() { 
			$(this).remove(); 
		});
		rows = data.split("@")
		for(i=0; i<rows.length-1; i++){
			details = rows[i].split("$")
			var opt = document.createElement('OPTION');
			opt.innerHTML = details[0];
			gradecatlist.appendChild(opt);
		}
	});
}

function getgradeitems(){
	$.post('../scripts/queries/getGradeItems',function(data){
		if(data.length>0){
			var tbody = document.getElementById("gradeitemtable").getElementsByTagName('TBODY')[0]
    		classes = data.split("@")
        	for(i=0; i<classes.length-1; i++){
	     		details = classes[i].split("$")

				var row = document.createElement('TR')
	
				var td1 = document.createElement('TD')
				td1.innerHTML = details[0];
				td1.setAttribute("style" , 'text-align:center');

		
				var td2 = document.createElement('TD')
				td2.setAttribute("class" , 'editmaxscore'); 
				td2.setAttribute("style" , 'text-align:center');
				td2.innerHTML = details[1]
				
				var td3 = document.createElement('TD')
				td3.setAttribute("style" , 'text-align:center');
				td3.innerHTML = details[2]

				var td4 = document.createElement('TD')
				var cn = document.createElement('center')
				var b = document.createElement('input')
				b.setAttribute("class" , 'delgradeitem'); 
 				b.setAttribute("type" , 'button');
				b.setAttribute("value", 'Delete');
				b.setAttribute("id", 'view_button');
				
				var b1 = document.createElement('input')
				b1.setAttribute("class" , 'viewgradeitem'); 
 				b1.setAttribute("type" , 'button');
				b1.setAttribute("value", 'View');
				b1.setAttribute("style", 'width: 50px');
				b1.setAttribute("id", 'view_button');
		
				row.appendChild(td1);
				row.appendChild(td2);
				cn.appendChild(b1);
				cn.appendChild(b);
				td4.appendChild(cn)
				row.appendChild(td3);
				row.appendChild(td4);
				tbody.appendChild(row);             
			}
		}
   
	});
}


function addgradeitem(name,maxscore,gradecat){
	var reg = new RegExp("^[+]?[0-9]+?[0-9]+$");
	if(!reg.test(maxscore)) {
		$().toastmessage('showErrorToast', 'Invalid Input');
		return;
	}
	
	var table = document.getElementById("gradeitemtable");
	var valid = true;
	for(var i = 1; i < table.rows.length; i++) {
   		 if(table.rows[i].cells[0].innerHTML.toLowerCase() == name.toLowerCase()) {
   		 	valid = false;
   		 	$().toastmessage('showErrorToast', table.rows[i].cells[0].innerHTML + ' ' + 'already exists!');
			return;
   		 }
	}
	if(valid) {
		$.post('../scripts/queries/addGradeItem',{name_:name,maxscore_:maxscore,gradecat_:gradecat},function(data){
			if(data == 'true') {
				var row = document.createElement('TR')
	
				var td1 = document.createElement('TD')
				td1.innerHTML = name;
				td1.setAttribute("style" , 'text-align:center');	
		
				var td2 = document.createElement('TD')
				td2.setAttribute("class" , 'editmaxscore'); 
				td2.setAttribute("style" , 'text-align:center');

				td2.innerHTML = maxscore;
				
				var td3 = document.createElement('TD')
				td3.setAttribute("style" , 'text-align:center');
				td3.innerHTML = gradecat;
	
				var td4 = document.createElement('TD')
				var cn = document.createElement('center')
				var b = document.createElement('input')
				b.setAttribute("class" , 'delgradeitem'); 
 				b.setAttribute("type" , 'button');
				b.setAttribute("value", 'Delete');
				b.setAttribute("id", 'view_button');
				
				var b1 = document.createElement('input')
				b1.setAttribute("class" , 'viewgradeitem'); 
 				b1.setAttribute("type" , 'button');
				b1.setAttribute("value", 'View');
				b1.setAttribute("style", 'width: 50px');
				b1.setAttribute("id", 'view_button');
	
				row.appendChild(td1);
				row.appendChild(td2);
				cn.appendChild(b1);
				cn.appendChild(b);
				td4.appendChild(cn);
				row.appendChild(td3);
				row.appendChild(td4);
				
				if($('#gradeitembody tr').length == 0) {
					$('#gradeitembody').prepend(row).children(':first').hide().fadeIn(1000, function() { });
					$().toastmessage('showSuccessToast', name + '  ' + 'added');
					return;
				}
					
				$('#gradeitembody tr').each(function(index){
					if(name.localeCompare(this.cells[0].innerHTML) == -1) {
						$(this).before(row).prev().hide().fadeIn(1000, function() { });
						$().toastmessage('showSuccessToast', name + '  ' + 'added');
						return false;
					}
					if($(this).is(':last-child')) {
    					$(this).after(row).next().hide().fadeIn(1000, function() { });
						$().toastmessage('showSuccessToast', name + '  ' + 'added');
					}																		    
				})			
			}
		});
	}
}

function editmaxscore(v,n){
	n.innerHTML = v
	var reg = new RegExp("^[+]?[0-9]+?[0-9]+$");
	if(!reg.test(v)) {
		$().toastmessage('showErrorToast', 'Invalid Input');
		n.parentNode.childNodes[1].revert();
		return false;
	}
		$.post('../scripts/queries/editMaxScore',{name_:n.parentNode.childNodes[0].innerHTML, maxscore_:n.innerHTML},function(data){
			if(data == 'true') {
				$().toastmessage('showNoticeToast', n.parentNode.childNodes[0].innerHTML + '  ' + 'updated');
				$(n).animate().hide().fadeIn(1000, function() { });
			}
		});
}

function deletegradeitem(n){
	$.post('../scripts/queries/deleteGradeItem',{name_:n.childNodes[0].innerHTML},function(data){
		if(data == 'true') {
			$().toastmessage('showErrorToast', n.childNodes[0].innerHTML + '  ' + 'deleted');
			$(n).animate().fadeOut(400,function(){ 
				$(n).remove()
			});
		}

	});
}

function getstudentgrades(n){
	$('#gradeitemlabel').html(n.parentNode.parentNode.parentNode.childNodes[0].innerHTML);
	$.post('../scripts/queries/getStudentGrades',{gradeitem_:n.parentNode.parentNode.parentNode.childNodes[0].innerHTML},function(data){
		if(data.length>0){
			var tbody = document.getElementById("studentgradeitems").getElementsByTagName('TBODY')[0]
    		classes = data.split("@")
        	for(i=0; i<classes.length-1; i++){
	     		details = classes[i].split("$")

				var row = document.createElement('TR')
	
				var td1 = document.createElement('TD')
				td1.innerHTML = details[0];
				td1.setAttribute("style" , 'text-align:center');

		
				var td2 = document.createElement('TD')
				td2.setAttribute("style" , 'text-align:center');
				td2.innerHTML = details[1]
				
				var td3 = document.createElement('TD')
				td2.setAttribute("class" , 'editstudscore');
				td3.setAttribute("style" , 'text-align:center');
				td3.innerHTML = details[2]

				var td4 = document.createElement('TD')
				var cn = document.createElement('center')
				var b = document.createElement('input')
				b.setAttribute("class" , 'delstudgrade'); 
 				b.setAttribute("type" , 'button');
				b.setAttribute("value", 'Delete');
				b.setAttribute("id", 'view_button');
		
				row.appendChild(td1);
				row.appendChild(td2);
				cn.appendChild(b);
				td4.appendChild(cn)
				row.appendChild(td3);
				row.appendChild(td4);
				tbody.appendChild(row);             
			}
		}
   
	});
}

function addstudentgrade(studentid,score,gradeitem){
	var reg = new RegExp("^[+]?[0-9]+?[0-9]+$");
	if(!reg.test(score)) {
		$().toastmessage('showErrorToast', 'Invalid Input');
		return;
	}
	
	var table = document.getElementById("studentgradeitems");
	var valid = true;
	for(var i = 1; i < table.rows.length; i++) {
   		 if(table.rows[i].cells[1].innerHTML.toLowerCase() == studentid.toLowerCase()) {
   		 	valid = false;
   		 	$().toastmessage('showErrorToast', table.rows[i].cells[1].innerHTML + ' ' + 'already exists!');
			return;
   		 }
	}
	if(valid) {
		$.post('../scripts/queries/addStudentGrade',{studentid_:studentid,score_:score,gradeitem_:gradeitem},function(data){
			if(data == 'true') {			
				$.post('../scripts/queries/getStudentGrades',{gradeitem_:gradeitem},function(data){
					classes = data.split("@")
	    			details = classes[0].split("$")
	    			
					var row = document.createElement('TR')
	
					var td1 = document.createElement('TD')
					td1.innerHTML = details[0];
					td1.setAttribute("style" , 'text-align:center');	
		
					var td2 = document.createElement('TD')
					td2.setAttribute("style" , 'text-align:center');
					td2.innerHTML = details[1];
				
					var td3 = document.createElement('TD')
					td2.setAttribute("class" , 'editstudscore');
					td3.setAttribute("style" , 'text-align:center');
					td3.innerHTML = details[2];
	
					var td4 = document.createElement('TD')
					var cn = document.createElement('center')
					var b = document.createElement('input')
					b.setAttribute("class" , 'delstudgrade'); 
 					b.setAttribute("type" , 'button');
					b.setAttribute("value", 'Delete');
					b.setAttribute("id", 'view_button');
	
					row.appendChild(td1);
					row.appendChild(td2);
					cn.appendChild(b);
					td4.appendChild(cn);
					row.appendChild(td3);
					row.appendChild(td4);
				
					if($('#sgibody tr').length == 0) {
						$('#sgibody').prepend(row).children(':first').hide().fadeIn(1000, function() { });
						$().toastmessage('showSuccessToast',  details[0] + '  ' + 'Added');
						return;
					}
					
					$('#sgibody tr').each(function(index){
						if(details[0].split(",")[0].localeCompare(this.cells[0].innerHTML.split(",")[0]) == -1) {
							$(this).before(row).prev().hide().fadeIn(1000, function() { });
							$().toastmessage('showSuccessToast', details[0] + '  ' + 'Added');
							return false;
						}
						if($(this).is(':last-child')) {
    						$(this).after(row).next().hide().fadeIn(1000, function() { });
							$().toastmessage('showSuccessToast', details[0] + '  ' + 'Added');
						}																	    
					});
				});
			}
			else
				$().toastmessage('showErrorToast', 'Student not found');

		});
	}
}

function autocomp() {
	$.post('../scripts/queries/studentIdAutoComp',function(data) {
		var t = data.split('@');
		//alert(eval('[' + data.split('@') + ']'));
		$( "#dfidnumber" ).autocomplete({
				source: t,
				close: function( event, ui ) {
                getstudentstats(this.value);
          	    }
			});
	});
}

function startsession() {
	$.post('../scripts/queries/startClassSession',function(data) {
		if(data == 'True') {
			var div1 = document.getElementById("dvattendance");
			var b = document.createElement('input')
			b.setAttribute("class" , 'endsessionbutton');
			b.setAttribute("type" , 'button');
			b.setAttribute("value", 'End Class');
			b.setAttribute("id", 'view_button');
			$('.startsessionbutton').animate().fadeOut(400,function() {
				$(this).remove();
				$(div1).append(b).animate().hide().fadeIn(1000, function() { })
			});
		}
	});
}

function endsession() {
	$.post('../scripts/queries/dismissClassSession',function(data) {
		$('#attendbody tr').each(function() { 
			$(this).animate().fadeOut(400,function(){ 
				$(this).remove()
			}); 
		});
		var div1 = document.getElementById("dvattendance");
		var b = document.createElement('input')
		b.setAttribute("class" , 'startsessionbutton');
		b.setAttribute("type" , 'button');
		b.setAttribute("value", 'Start Class');
		b.setAttribute("id", 'view_button');
		$('.endsessionbutton').animate().fadeOut(400,function() {
			$(this).remove();
			$(div1).append(b).animate().hide().fadeIn(1000, function() { })
		});

		
	});
}

function getstudentstats(idnum) {
	document.getElementById("frmpic").src = "images/ajax-loader.gif";
	$.post('../scripts/queries/getStudentStats',{idnum_:idnum},function(data){
  		if(data.length>0){
    		info = data.split("#")
          	document.getElementById("dfname").value = info[1]
          	document.getElementById("dfcourse").value = info[2]
          	document.getElementById("frmpic").src = "images/users/" + info[6];
       	}
	});
}
