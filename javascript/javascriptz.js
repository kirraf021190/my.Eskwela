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
          info = data.split(",")
          var table = document.getElementById('userinfo') 
          table.rows[1].cells[1].innerHTML = info[0]
          table.rows[2].cells[1].innerHTML = info[1]
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

	var td9 = document.createElement('TD')
	td9.innerHTML = '<center><input type="button" value="View" id="view_button" onclick="location.href=\'../scripts/form/section?sec='+details[1]+'&scode='+details[6]+'\'"></center>'
	
	var td10 = document.createElement('TD')
	td10.innerHTML = details[6];
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
	     details = classes[i].split("$")
	     
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
getgradesystem();
getgradeitems();
refreshtab();
}

function addAttendance(idnum){

	$.post('../scripts/queries/addAttendance',{idnum_:idnum},function(data){
		if(data == 'true') {
			$.post('../../scripts/queries/getAttendanceBySubject',function(data){
				if(data.length>0){
          			classes = data.split("@")
	    			details = classes[0].split("$")
	     
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
									
					row.appendChild(td1);
					row.appendChild(td2);
					row.appendChild(td3);
					row.appendChild(td4);
					$(tbody).prepend(row).children(':first').hide().fadeIn(1000, function() { });
					$().toastmessage('showSuccessToast', 'Attendance Logged');		
                }
    		});
		}
		else
			$().toastmessage('showErrorToast', 'Student Not Found');
	});
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
	
				row.appendChild(td1);
				row.appendChild(td2);
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



