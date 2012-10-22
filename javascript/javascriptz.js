function getStudInfo() {
  getestudyanteClasses()
  $.post('../scripts/queries/getInfo',function(data){
  if(data.length>0){
          info = data.split("#")
          var table = document.getElementById('userinfo') 
          table.rows[1].cells[1].innerHTML = info[1]
          table.rows[2].cells[1].innerHTML = info[0]
          table.rows[3].cells[1].innerHTML = info[3]
          table.rows[4].cells[1].innerHTML = info[5]
		 document.getElementById("profilepic").src = "images/users/" + info[6];
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
          document.getElementById("profilepic").src = "images/users/" + info[4];

          
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
	     
            	var tbody = document.getElementById("students_attendance").getElementsByTagName('TBODY')[0];
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
    });
	getenrollednames();
	getgradesystem();
//refreshtab();
}

function addAttendance(idnum){
	var isvalid = true;
	$('#attendbody tr').each(function(index){
		if(this.cells[0].innerHTML == idnum ) {
			$().toastmessage('showErrorToast', this.cells[1].innerHTML + '  ' + 'is already logged in!');
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
					$.post('../scripts/queries/getCurrentSession',function(data){
						if(data == '0') {
							$().toastmessage('showErrorToast', 'Class not started');
						}
						else {
							$().toastmessage('showErrorToast', 'Student is already logged in!');
						}
					});
				
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
	     		details = classes[i].split("#")
	     
       		 	var tbody = document.getElementById("users").getElementsByTagName('TBODY')[0];
				var row = document.createElement('TR')
	
				var td1 = document.createElement('TD')
				td1.innerHTML = details[1];
		
				var td2 = document.createElement('TD')
				td2.setAttribute("class" , 'edit'); 
				td2.innerHTML = details[2]

				var td3 = document.createElement('TD')
				var cn = document.createElement('center')
				var b = document.createElement('input')
				b.setAttribute("class" , 'del'); 
 				b.setAttribute("type" , 'button');
				b.setAttribute("value", 'Delete');
				b.setAttribute("id", 'view_button');
	
				var td4 = document.createElement('TD')
				td4.setAttribute("class" , 'edit'); 
				td4.setAttribute("style", 'display: none');
				td4.innerHTML = details[0]
	
				gradecatlist = document.getElementById("gradecat");
				if(classes[0] != "None"){
					var opt = document.createElement('OPTION');
					opt.innerText = details[1];
					opt.value = details[0];
					$('#gradecat').append(opt);
				}
		
				row.appendChild(td1);
				row.appendChild(td2);
				cn.appendChild(b);
				td3.appendChild(cn)
				row.appendChild(td3);
				row.appendChild(td4);
				if(classes[0] != "None"){
					tbody.appendChild(row); 
				}
				if(i == classes.length-2){
					$(function() {
						$("#gradecat").selectbox({
							onOpen: function (inst) {
								$('.gradezitemz').hide("fade", { direction: "up"}, 500, function() {
									$(document.getElementById("gradeitembody").childNodes).each(function() { 
										$(this).remove(); 
			 						});
								});
								$('#classrecordz').hide("fade", { direction: "up"}, 500, function() {
									$(document.getElementById("classrecordheader").childNodes).each(function() { 
			 							if(this.innerHTML != "Name")
											$(this).remove(); 
			 						});
			 						$(document.getElementById("classrecordbody").childNodes).each(function() { 
											$(this).remove(); 
			 						});
								});
								$('#viewgradeitemz').hide("fade", { direction: "up"}, 500, function() {
									$(document.getElementById("sgibody").childNodes).each(function() { 
										$(this).remove(); 
			 						});
								});
							},
							onChange: function (val, inst) {
								if(val != "Select Category") {
									getgradeitems(val);
									
								}
							},
						effect: "slide"
						});
					});
				}
			}
			sumofcategories();
		}
       
	});
	
}


function setGradeSystem(name,weight){
	var table = document.getElementById("users");
	var temp = 0;
	var valid = true;
	var reg = new RegExp("^[+]?[0-9]+$");
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
			if(data == 'True') {			
				$.post('../scripts/queries/getGradeSystem',function(data) {
					if(data.length>0){
         				classes = data.split("@")
          				for(i=0; i<classes.length-1; i++){
          					details = classes[i].split("#")
          					if(details[1] == name && details[2] == weight) {
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
								
								var td4 = document.createElement('TD')
								td4.setAttribute("class" , 'edit'); 
								td4.setAttribute("style", 'display: none');
								td4.innerHTML = details[0]
	
								row.appendChild(td1);
								row.appendChild(td2);
								cn.appendChild(b);
								td3.appendChild(cn)
								row.appendChild(td3);
								row.appendChild(td4);
								
								$(function() {
									$("#gradecat").selectbox("detach")
									gradecatlist = document.getElementById("gradecat");
									var opt = document.createElement('OPTION');
									opt.innerText = details[1];
									opt.value = details[0];
									$('#gradecat').append(opt);
									$("#gradecat").selectbox({
										onOpen: function (inst) {
													$('.gradezitemz').hide("fade", { direction: "up"}, 500, function() {
														$(document.getElementById("gradeitembody").childNodes).each(function() { 
															$(this).remove(); 
			 											});
													});
													
													$('#classrecordz').hide("fade", { direction: "up"}, 500, function() {
														$(document.getElementById("classrecordheader").childNodes).each(function() { 
			 												if(this.innerHTML != "Name")
																$(this).remove(); 
			 											});
			 											$(document.getElementById("classrecordbody").childNodes).each(function() { 
															$(this).remove(); 
			 											});
													});
													
													$('#viewgradeitemz').hide("fade", { direction: "up"}, 500, function() {
														$(document.getElementById("sgibody").childNodes).each(function() { 
															$(this).remove(); 
			 											});
													});
												},
										onChange: function (val, inst) {
													if(val != "Select Category") {
														getgradeitems(val);
													}
												},
										effect: "slide"
									});
								});	

								if($('#gradecattablebody tr').length == 0) {
									$("#gradecattablebody").prepend(row).children(':first').hide().fadeIn(1000, function() { });
									$().toastmessage('showSuccessToast', name + '  ' + 'added');
									sumofcategories();
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
							sumofcategories();
          					}
						}
					}
				});
				
			}
		});
	}
}

function editweight(v,n){
	n.innerHTML = v
	var table = document.getElementById("users");
	var temp = 0;
	var reg = new RegExp("^[+]?[0-9]+$");
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
		$.post('../scripts/queries/editCatWeight',{catid_:n.parentNode.childNodes[3].innerHTML, weight_:n.innerHTML},function(data){
			$().toastmessage('showNoticeToast', n.parentNode.childNodes[0].innerHTML + '  ' + 'updated');
			$(n).animate().hide().fadeIn(1000, function() { });
		});
	}
	sumofcategories();

}

function deletecat(n){
	$.post('../scripts/queries/deleteCategory',{catid_:n.childNodes[3].innerHTML},function(data){
		if(data == 'True') {
			$().toastmessage('showErrorToast', n.childNodes[0].innerHTML + '  ' + 'deleted');
			$(n).animate().fadeOut(400,function(){ 
				$(n).remove()
				sumofcategories();
			});
			$("#gradecat").val(0);
			$('.gradezitemz').hide();
			$(document.getElementById("gradeitembody").childNodes).each(function() { 
				$(this).remove(); 
			 });
			$('#viewgradeitemz').hide();
			$(document.getElementById("sgibody").childNodes).each(function() { 
				$(this).remove();
			});
			$(document.getElementById("classrecordheader").childNodes).each(function() { 
				if(this.innerHTML != "Name")
					$(this).remove(); 
			 });
			$(document.getElementById("classrecordbody").childNodes).each(function() { 
				$(this).remove(); 
			});
			$('#classrecordz').hide();		
			$(function() {
									$("#gradecat").selectbox("detach")
									gradecatlist = document.getElementById("gradecat");
									$("option[value='"+n.childNodes[3].innerHTML+"']").remove();
									$("#gradecat").selectbox({
										onOpen: function (inst) {
													$('.gradezitemz').hide("fade", { direction: "up"}, 500, function() {
														$(document.getElementById("gradeitembody").childNodes).each(function() { 
															$(this).remove(); 
			 											});
													});
													
													$('#classrecordz').hide("fade", { direction: "up"}, 500, function() {
														$(document.getElementById("classrecordheader").childNodes).each(function() { 
			 												if(this.innerHTML != "Name")
																$(this).remove(); 
			 											});
			 											$(document.getElementById("classrecordbody").childNodes).each(function() { 
															$(this).remove(); 
			 											});
													});
													
													$('#viewgradeitemz').hide("fade", { direction: "up"}, 500, function() {
														$(document.getElementById("sgibody").childNodes).each(function() { 
															$(this).remove(); 
			 											});
													});
												},
										onChange: function (val, inst) {
												  	if(val != "Select Category") {
														getgradeitems(val);
													}
												},
										effect: "slide"
									});
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

function getgradeitems(v){
	$.post('../scripts/queries/getGradeItems',{catid_:v},function(data){
		if(data.length>0){
			var tbody = document.getElementById("gradeitemtable").getElementsByTagName('TBODY')[0]
    		classes = data.split("@")
        	for(i=0; i<classes.length-1; i++){
	     		details = classes[i].split("#")

				var row = document.createElement('TR')
	
				var td1 = document.createElement('TD')
				td1.innerHTML = details[1];
				td1.setAttribute("style" , 'text-align:center');

		
				var td2 = document.createElement('TD')
				td2.setAttribute("class" , 'editmaxscore'); 
				td2.setAttribute("style" , 'text-align:center');
				td2.innerHTML = details[2]
				
				var td3 = document.createElement('TD')
				td3.setAttribute("style" , 'text-align:center');
				td3.innerHTML = details[3]
				
				var td5 = document.createElement('TD')
				td5.setAttribute("class" , 'edit'); 
				td5.setAttribute("style", 'display: none');
				td5.innerHTML = details[0]

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
				row.appendChild(td5);
				tbody.appendChild(row);
				
				var th = document.createElement('TH')
				th.innerHTML = details[1]				
				$('#classrecordheader').append(th);	
			}
		}
		populateclassrecord();
   		$('.gradezitemz').show("fade", { direction: "up" }, 500,function() {
		});
	});
}


function addgradeitem(name,maxscore){
	var reg = new RegExp("^[+]?[0-9]+$");
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
		$.post('../scripts/queries/addGradeItem',{name_:name,maxscore_:maxscore,catid_:$('#gradecat :selected').val()},function(data){
			if(data == 'True') {
				$.post('../scripts/queries/getGradeItems',{catid_:$('#gradecat :selected').val()},function(data){
					var tbody = document.getElementById("gradeitemtable").getElementsByTagName('TBODY')[0]
    				classes = data.split("@")
        			for(i=0; i<classes.length-1; i++){
	     				details = classes[i].split("#")
	     				if(details[1] == name && details[2] == maxscore){
							var row = document.createElement('TR')
	
							var td1 = document.createElement('TD')
							td1.innerHTML = details[1];
							td1.setAttribute("style" , 'text-align:center');

							var td2 = document.createElement('TD')
							td2.setAttribute("class" , 'editmaxscore'); 
							td2.setAttribute("style" , 'text-align:center');
							td2.innerHTML = details[2]
				
							var td3 = document.createElement('TD')
							td3.setAttribute("style" , 'text-align:center');
							td3.innerHTML = details[3]
				
							var td5 = document.createElement('TD')
							td5.setAttribute("class" , 'edit'); 
							td5.setAttribute("style", 'display: none');
							td5.innerHTML = details[0]

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
							row.appendChild(td5);
						
							$('#gradeitembody').append(row).children(':last').hide().fadeIn(1000, function() { });
							$().toastmessage('showSuccessToast',  details[1] + '  ' + 'Added');
							/*if($('#gradeitembody tr').length == 0) {
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
							});*/
						}
					}
				})
				updateclassrecordadd(name);
			}
		})
	}
}

function editmaxscore(v,n){
	n.innerHTML = v
	var reg = new RegExp("^[+]?[0-9]+$");
	if(!reg.test(v)) {
		$().toastmessage('showErrorToast', 'Invalid Input');
		n.parentNode.childNodes[1].revert();
		return false;
	}
		$.post('../scripts/queries/editMaxScore',{gradeitemid_:n.parentNode.childNodes[4].innerHTML, maxscore_:n.innerHTML},function(data){
			if(data == 'True') {
				$().toastmessage('showNoticeToast', n.parentNode.childNodes[0].innerHTML + '  ' + 'updated');
				$(n).animate().hide().fadeIn(1000, function() { });
			}
		});
}

function deletegradeitem(n){
	$.post('../scripts/queries/deleteGradeItem',{name_:n.childNodes[4].innerHTML},function(data){
		if(data == 'True') {
			$().toastmessage('showErrorToast', n.childNodes[0].innerHTML + '  ' + 'deleted');
			$(n).animate().fadeOut(400,function(){ 
				$(n).remove()
			});
			deleteclassrecord(n.childNodes[0].innerHTML);
		}

	});
}

function getstudentgrades(n){
	$('#gradeitemlabel').html(n.parentNode.parentNode.parentNode.childNodes[0].innerHTML);
	$('#gradeitemidlabel').html(n.parentNode.parentNode.parentNode.childNodes[4].innerHTML);
	$.post('../scripts/queries/getStudentGrades',{gradeitemid_:n.parentNode.parentNode.parentNode.childNodes[4].innerHTML},function(data){
		if(data.length>0){
			var tbody = document.getElementById('sgibody');
    		classes = data.split("@")
        	for(i=0; i<classes.length-1; i++){
	     		details = classes[i].split("#")
				var row = document.createElement('TR')
	
				var td1 = document.createElement('TD')
				td1.innerHTML = details[2];
				td1.setAttribute("style" , 'text-align:center');

		
				var td2 = document.createElement('TD')
				td2.setAttribute("style" , 'text-align:center');
				td2.innerHTML = details[1]
				
				var td3 = document.createElement('TD')
				td3.setAttribute("class" , 'editstudscore');
				td3.setAttribute("style" , 'text-align:center');
				td3.innerHTML = details[3]

				var td4 = document.createElement('TD')
				var cn = document.createElement('center')
				var b = document.createElement('input')
				b.setAttribute("class" , 'delstudgrade'); 
 				b.setAttribute("type" , 'button');
				b.setAttribute("value", 'Delete');
				b.setAttribute("id", 'view_button');
				
				var td5 = document.createElement('TD')
				td5.setAttribute("style", 'display: none');
				td5.innerHTML = details[0]
		
				row.appendChild(td1);
				row.appendChild(td2);
				cn.appendChild(b);
				td4.appendChild(cn)
				row.appendChild(td3);
				//row.appendChild(td4);
				row.appendChild(td5);
				tbody.appendChild(row);           
			}
		}
   
	});
}

function addstudentgrade(studentid,score){
	var reg = new RegExp("^[+]?[0-9]+$");
	if(!reg.test(score)) {
		$().toastmessage('showErrorToast', 'Invalid Input');
		return;
	}
	
	var table = document.getElementById("studentgradeitems");
	var valid = true;
	/*for(var i = 1; i < table.rows.length; i++) {
   		 if(table.rows[i].cells[1].innerHTML.toLowerCase() == studentid.toLowerCase()) {
   		 	valid = false;
   		 	$().toastmessage('showErrorToast', table.rows[i].cells[1].innerHTML + ' ' + 'already exists!');
			return;
   		 }
	}*/
	if(valid) {
		$.post('../scripts/queries/addStudentGrade',{studentid_:studentid,score_:score,gradeitemid_:$('#gradeitemidlabel').html()},function(data){
			if(data == 'True') {
				for(var i = 1; i < table.rows.length; i++) {
   		 			if(table.rows[i].cells[1].innerHTML.toLowerCase() == studentid.toLowerCase()) {
   		 			
   		 				table.rows[i].cells[2].innerHTML = score ; 			
   		 				$(table.rows[i].cells[2]).effect("highlight", {color: "#A9F5A9" }, 600);
   		 				
   		 				var triangulate = document.getElementById("classrecord");
   		 				var rowz;
   		 				var col = $("#classrecordheader th:contains('"+$("#gradeitemlabel").text()+"')").index()
   		 					
   		 				$("#classrecordbody tr").each(function() { 		
							if($(this).children(":nth-child(1)").text() == table.rows[i].cells[0].innerHTML) {
								rowz = $(this).index();
								return false;
							}
						});
						
						$(triangulate.rows[rowz+1].cells[col]).text(score);
						$(triangulate.rows[rowz+1].cells[col]).effect("highlight", {color: "#A9F5A9" }, 600);
   		 			}					
				}
				$().toastmessage('showSuccessToast', 'Grade Added');
				$('#addstudscore').val( '' );
				if(document.getElementById("addstudid").selectedIndex != $("#addstudid option").length -1)
					document.getElementById("addstudid").selectedIndex = document.getElementById("addstudid").selectedIndex + 1;
				else
					document.getElementById("addstudid").selectedIndex = 0;
			}
			else
				$().toastmessage('showErrorToast', 'Student not found');

		});
	}
}

function deletestudentgrade(n){
	$.post('../scripts/queries/deleteStudentGrade',{gradeid_:n.childNodes[4].innerHTML},function(data){
		if(data == 'True') {
			$().toastmessage('showErrorToast', n.childNodes[1].innerHTML + '  ' + 'deleted');
			$(n).animate().fadeOut(400,function(){ 
				$(n).remove()
			});
		}

	});
}

function editstudentgrade(v,n){
	n.innerHTML = v
	var reg = new RegExp("^[+]?[0-9]+$");
	if(!reg.test(v)) {
		$().toastmessage('showErrorToast', 'Invalid Input');
		n.parentNode.childNodes[1].revert();
		return false;
	}
		$.post('../scripts/queries/editStudentGradeScore',{gradeitemid_:n.parentNode.childNodes[3].innerHTML, newscore_:n.innerHTML},function(data){
			if(data == 'True') {
				var triangulate = document.getElementById("classrecord");
				$().toastmessage('showNoticeToast', n.parentNode.childNodes[1].innerHTML + '  ' + 'updated');
				$(n).animate().hide().fadeIn(1000, function() { });
				var rowz;
			    var col = $("#classrecordheader th:contains('"+$("#gradeitemlabel").text()+"')").index()
			    $("#classrecordbody tr").each(function() { 		
					if($(this).children(":nth-child(1)").text() == n.parentNode.childNodes[0].innerHTML) {
						rowz = $(this).index();
						return false;
					}
				});
				$(triangulate.rows[rowz+1].cells[col]).text(v);
				$(triangulate.rows[rowz+1].cells[col]).effect("highlight", {color: "#A9F5A9" }, 600);
			}
		});
}

function autocomp(inst) {
	$.post('../scripts/queries/studentIdAutoComp',function(data) {
		var t = data.split('@');
		//alert(eval('[' + data.split('@') + ']'));
		$(inst).autocomplete({
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
				$().toastmessage('showNoticeToast', 'Class started');
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
			$().toastmessage('showNoticeToast', 'Class dismissed');
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
          	$.post('../scripts/queries/countAbsences',{idnum_:idnum},function(data){
          		document.getElementById("dfabsentcount").value = data
			});
       	}
	});
}

function getenrollednames() {
	$.post('../scripts/queries/getEnrolledNames',function(data) {
		var names = data.split('@');
		for(i=0; i<names.length-1; i++){
			details = names[i].split("#")
			var opt = document.createElement('OPTION');
			opt.innerText = details[1];
			opt.value = details[0];
			$('#enrolledlist').append(opt);
			
			var opt2 = document.createElement('OPTION');
			opt2.innerText = details[0];
			opt2.value = details[0];
			$('#addstudid').append(opt2);
			
			if(i == names.length-2){
					$(function() {
						$("#enrolledlist").selectbox({
							onOpen: function (inst) {
								$('#viewstudinfo').hide("fade", { direction: "up"}, 500, function() {
									$(document.getElementById("viewabsencesbody").childNodes).each(function() { 
										$(this).remove(); 
			 						});
								});
							},
							onChange: function (val, inst) {
								if(val != "Select Student") {
									viewstudentstats(val);
									getsessionabsences(val);
									getstandinggrade(val);
									$('#viewstudinfo').show("fade", { direction: "up" }, 500,function() {
									});
								}
							},
						effect: "slide"
						});
					});
				}
		}
	});
}

function sumofcategories() {
	var temp = 0;
	var table = document.getElementById("users");
	for(var i = 1; i < table.rows.length; i++) {
		temp = temp + parseInt(table.rows[i].cells[1].innerHTML);
	}
	$('#gradecattotal').text('Total Weight: ' + temp + '%');
}

function viewstudentstats(idnum) {
	$.post('../scripts/queries/getStudentStats',{idnum_:idnum},function(data){
		if(data.length>0){
    		info = data.split("#")
          	document.getElementById("studviewid").innerHTML = info[0]
          	document.getElementById("studviewname").innerHTML = info[1]
          	document.getElementById("studviewcourse").innerHTML = info[3]
          	document.getElementById("studviewemail").innerHTML = info[5]
          	document.getElementById("studentviewpic").src = "images/users/" + info[6];
       	}
	});
}

function getsessionabsences(idnum) {
	$.post('../scripts/queries/getSessionAbsences',{idnum_:idnum},function(data){
		if(data.length>0){
    		var tbody = document.getElementById('viewabsencesbody');
    		abs = data.split("@")
        	for(i=0; i<abs.length-1; i++){
        		details = abs[i].split("#");
				var row = document.createElement('TR')
	
				var td1 = document.createElement('TD')
				td1.innerHTML = details[1];
					
				var td2 = document.createElement('TD')
				td2.innerHTML = details[2];
					
				row.appendChild(td1);
				tbody.appendChild(row); 			
       		}
       	}
    });
}

function getstandinggrade(idnum) {
	$.post('../scripts/queries/getStandingGrade',{idnum_:idnum},function(data){
		$('#studentviewgrade').text('Standing grade: ' +data+ '%');
	});
}


function populateclassrecord() {
	$.post('../scripts/queries/populateClassRecord',{catid_:$('#gradecat :selected').val()},function(data) {
		if(data.length>0){
    		rowz = data.split("@")
        	for(i=0; i<rowz.length-1; i++){
        		var row = document.createElement('TR');
        		details = rowz[i].split("#");
        		for(j=0; j< details.length; j++){      		
					var td1 = document.createElement('TD');
					td1.innerHTML = details[j];
					row.appendChild(td1);				     
				}
				$('#classrecordbody').append(row);				
        	}
        	$('#classrecordz').show("fade", { direction: "up" }, 500,function() {
			});
        }
	});
}

function updateclassrecordadd(gradeitemname) {
	var th = document.createElement('TH')
	th.innerHTML = gradeitemname;			
	$('#classrecordheader').append(th).children(':last').hide().fadeIn(1000, function() { });
	
	$('#classrecordbody tr').each(function() { 
		var td1 = document.createElement('TD');
		td1.innerHTML = 0;
		$(this).append(td1).children(':last').hide().fadeIn(1000, function() { });
	})
	
}

function deleteclassrecord(n){
	var col = $("#classrecordheader th:contains('"+n+"')").index() + 1;
	$("#classrecordheader th:contains('"+n+"')").remove();
	$("#classrecordbody tr").each(function() { 		
		$(this).children(":nth-child("+col+")").remove();
	});	
}

//***********  PARENT SIDE ***********//

function getParentInfo() {
  $.post('../scripts/queries/getInfo',function(data){
  if(data.length>0){
          info = data.split("#")
          var table = document.getElementById('userinfo') 
          table.rows[1].cells[1].innerHTML = info[1]
          table.rows[2].cells[1].innerHTML = info[0]
          table.rows[3].cells[1].innerHTML = info[2]
          document.getElementById("profilepic").src = "images/users/" + info[3];
		  getchildrennames();
       }
	});
	
}

function getchildrennames() {
	$.post('../scripts/queries/getChildrenNames',function(data) {
		var names = data.split('@');
		for(i=0; i<names.length-1; i++){
			details = names[i].split("#")
			var opt = document.createElement('OPTION');
			opt.innerText = details[1];
			opt.value = details[0];
			$('#childrenlist').append(opt);
			if(i == names.length-2){
				$("#childrenlist").selectbox({
							onOpen: function (inst) {
								$('#parentviewchildren').hide("fade", { direction: "up" }, 500,function() {
									$('#akongaccordion').empty();
									$('#akongaccordion').accordion('destroy');
								});
							},
							onChange: function (val, inst) {
								if(val != "Select Student") {
									$('#parentviewchildren').show("fade", { direction: "up" }, 500,function() {
									});
									getchildreninfo(val);
									parentviewer(val);
								}
							},
						effect: "slide"
				});
			}
		}
	});
}

function getchildreninfo(idnum) {
	$.post('../scripts/queries/getStudentStats',{idnum_:idnum},function(data){
		if(data.length>0){
    		info = data.split("#")
          	document.getElementById("studviewid").innerHTML = info[0]
          	document.getElementById("studviewname").innerHTML = info[1]
          	document.getElementById("studviewcourse").innerHTML = info[3]
          	document.getElementById("studviewemail").innerHTML = info[5]
          	document.getElementById("studentviewpic").src = "images/users/" + info[6];
       	}
	});
}

function parentviewer(idnum) {
	$.post('../scripts/queries/parentViewer',{idnum_:idnum},function(data){
		if(data.length>0){
			classes = data.split("@")
        	for(i=0; i<classes.length-1; i++){
	     		details = classes[i].split("#")
	     		
	     		var div = document.createElement('div')
	
				var td1 = document.createElement('h3')
				td1.innerHTML = details[1];
		
				var p1 = document.createElement('p')
				p1.innerHTML = details[3];
				p1.setAttribute("style", 'font-weight:bold');
				
				var p2 = document.createElement('p')
				p2.innerHTML = details[2];
				p2.setAttribute("style", 'font-weight:bold');
	
				var p3 = document.createElement('p')
				p3.innerHTML = details[4];
				p3.setAttribute("style", 'font-weight:bold');
				
				var p4 = document.createElement('p')
				p4.innerHTML = 'Sessions Attended: ' + details[9];
				p4.setAttribute("style", 'font-weight:bold');
				
				var p5 = document.createElement('p')
				p5.innerHTML = 'Standing Grade: ' + details[10]+ '%';
				p5.setAttribute("style", 'font-weight:bold;color:#FF0000');	
				
				var hr = document.createElement('hr')
				hr.setAttribute("width", '50%');	
				hr.setAttribute("align", 'left');
				
				var hr1 = document.createElement('hr')
				hr1.setAttribute("width", '50%');	
				hr1.setAttribute("align", 'left');
				
				var hr2 = document.createElement('hr')
				hr2.setAttribute("width", '50%');	
				hr2.setAttribute("align", 'left');
				
				var hr3 = document.createElement('hr')
				hr3.setAttribute("width", '50%');	
				hr3.setAttribute("align", 'left');
						
				div.appendChild(p1);
				div.appendChild(hr);
				div.appendChild(p2);
				div.appendChild(hr1);
				div.appendChild(p3);
				div.appendChild(hr2);
				div.appendChild(p4);
				div.appendChild(hr3);
				div.appendChild(p5);

				
				$('#akongaccordion').append(td1);
				$('#akongaccordion').append(div);
			}
			$('#akongaccordion').accordion({ header: "h3", collapsible: true, active: false });
		}
	     		
	});
}

function getestudyanteClasses(){
    $.post('../scripts/queries/studViewer',function(data){
       if(data.length>0){
          classes = data.split("@")
          for(i=0; i<classes.length-1; i++){
         details = classes[i].split("#")
         
             var tbody = document.getElementById
    ("studView").getElementsByTagName('TBODY')[0];
    var row = document.createElement('TR')
    
    var td1 = document.createElement('TD')
    td1.innerHTML = details[1];
        
    var td2 = document.createElement('TD')
    td2.innerHTML = details[2];
    
    var td3 = document.createElement('TD')
    td3.innerHTML = details[3];
        
    var td4 = document.createElement('TD')
    td4.innerHTML = details[10];
        
    var td5 = document.createElement('TD')
    td5.innerHTML = details[9];

        
        row.appendChild(td1);
        row.appendChild(td2);
        row.appendChild(td3);
        row.appendChild(td4);
        row.appendChild(td5);
        tbody.appendChild(row);             
      }
       }
    });
}


