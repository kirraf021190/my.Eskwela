function checkSession(){
	  $.post('../scripts/form/checkSessionJs',function(data){
       if(data.length>0){
          if(data == "False"){
		location.href="../scripts/login"
	 }
       }
    });
}
function getClasses(){

    checkSession()
    getProfInfo()
	
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

	var td8 = document.createElement('TD')
	td8.innerHTML = details[7];	

	var td9 = document.createElement('TD')
	td9.innerHTML = '<center><input type="button" value="View" id="view_button" onclick="location.href=\'../scripts/form/section?sec='+details[1]+'&sy='+details[8]+'&subj='+details[0]+'&code='+details[9]+'\'"></center>'
	
		
		row.appendChild(td1);
		row.appendChild(td2);
		row.appendChild(td3);
		row.appendChild(td4);
		row.appendChild(td5);
		row.appendChild(td6);
		row.appendChild(td7);
		row.appendChild(td8);
		row.appendChild(td9);
		tbody.appendChild(row);             
	  }
       }
    });
}
function getProfInfo(){

     $.post('../scripts/queries/getTeacherInfo',function(data){
       if(data.length>0){
          info = data.split("$")
          var table = document.getElementById('teacherInfo') 
          table.rows[1].cells[1].innerHTML = info[0]
          table.rows[2].cells[1].innerHTML = info[1]
          table.rows[3].cells[1].innerHTML = info[2]
          table.rows[4].cells[1].innerHTML = info[3]
          table.rows[0].cells[0].innerHTML = '<image src="pictures/'+info[4]+'" class="r51" id="frmpic">'
       }
    });
    
}


function getStudents(){ 
	checkSession()
	getSubjectName();
	getScale();
}

function getSubjectName(){
	 $.post('../scripts/queries/getSubjName',function(data){
       if(data.length>0){
          head = data.split("@")
         for(i=0; i<head.length-1; i++){
		details = head[i].split('$')
		document.getElementById("subjcode").innerHTML = details[0];
		/*document.getElementById("subname").innerHTML = details[1];
		document.getElementById("type").innerHTML = details[2];
		document.getElementById("sec_code").innerHTML = details[3];
		document.getElementById("subj_time").innerHTML = details[4];*/

	}
       }
    });	
}

// modified: sept. 25, 2011
function getHeader() {   
$.post('../scripts/queries/getHeaderReport',function(data){
	
	var jsonObject = $.parseJSON(data);	
	var tbody = document.getElementById
	("students").getElementsByTagName('TBODY')[0];
	var row = document.createElement('TR')	
	var td0 = document.createElement('TD')	
	var td1 = document.createElement('TD')
	var td2 = document.createElement('TD')		
	row.appendChild(td0);
	row.appendChild(td1);
	row.appendChild(td2);
	$.each(jsonObject.categories, function(key, val) {
		 
               var tblHeadObj = document.getElementById('students').tHead; //table head
                 var newTH = document.createElement('th');
		 if(val.grpPerformance.length>=1){
		 	newTH.colSpan = ""+(val.grpPerformance.length+1)+""
		}
                 tblHeadObj.rows[0].appendChild(newTH); //append ne th to table
                 newTH.innerHTML = val.category+"("+val.weight+")";
		
  	});
	$.each(jsonObject.categories, function(key, val) {
		$.each(val.grpPerformance, function(key2, val2) {
			
			var td3 = document.createElement('TD')
			if(key2 < val.grpPerformance.length){			
				td3.innerHTML = val2.grpPerfName+"("+val2.items+")";
			}
			row.appendChild(td3);
			
		});
			var td4 = document.createElement('TD')
			td4.innerHTML = "<b>Total</b>";
			row.appendChild(td4);
		
	});
	tbody.appendChild(row); 
        getStudentsGrades(jsonObject);
       });
	
   }

function getStudentsGrades(jsonHeaders){
	$.post('../scripts/queries/getStudentGradesReport', function(data){
		var grades = $.parseJSON(data);
		showStudentsGradeReport(jsonHeaders, grades);
	});
}

function showStudentsGradeReport(headings, grades){
	

	$.post('../scripts/queries/getSectionStudents',function(data){
       if(data.length>0){
          stud = data.split("@")

	for(i=0; i<stud.length-1; i++){
	     details = stud[i].split("$")
	     
		var tbody = document.getElementById
		("students").getElementsByTagName('TBODY')[0];
		var row = document.createElement('TR')
	
		var td1 = document.createElement('TD')
		td1.innerHTML = details[1];
		
		var td2 = document.createElement('TD')
		td2.innerHTML = details[0];
	
		
		var td4 = document.createElement('TD')
			row.appendChild(td1);
			row.appendChild(td2);
			

		var studGrade = null;
		$.each(grades.data, function(key1, val1){
			if(val1.student == details[0]){
				studGrade = val1;
			}
		});

		td4.innerHTML = "("+studGrade.scale+") "+(studGrade.grade*100).toFixed(2);
		row.appendChild(td4);

		$.each(headings.categories, function(key, val) {
		 	
			
			var category = null
			$.each(studGrade.categories, function(key2, val2){
				if(val.id == val2.catId){
					category = val2;				
				}		
			});
			var td6 = document.createElement('TD')
			
			if(category != null){
				$.each(category.grpPerformances, function(key3, val3){
					
					if(val3 != null){
						var td5 = document.createElement('TD')
						td5.innerHTML = val3.score
						td5.align = 'right';
						row.appendChild(td5);
					}
				});
				
				td6.innerHTML = (category.total*100).toFixed(2)
				td6.align = 'right';
				row.appendChild(td6);
			}else{
				td6.innerHTML = 0.00
				row.appendChild(td6);
			}
			
	  	});
			
			tbody.appendChild(row); 
            
	  }
       }
    });
}

// end here
function getCategories(){
	 $.post('../scripts/queries/getCategories',function(data){
       if(data.length>0){
          cat = data.split("@")
         for(i=0; i<cat.length-1; i++){
		details = cat[i].split("$")
		var tbody = document.getElementById
		("users").getElementsByTagName('TBODY')[0];
		var row = document.createElement('TR')
	
		var td1 = document.createElement('TD')
		td1.innerHTML = details[1];
		
		var td2 = document.createElement('TD')
		td2.innerHTML = details[2];
	
		var td3 = document.createElement('TD')
		td3.innerHTML = details[3];

		var td4 = document.createElement('TD')
		td4.innerHTML = '<img class="delete" src="pictures/delete.gif" onclick="remCategory(this)"> <img src="pictures/edit_icon.png" onclick="openUpdateCatDialog(\''+details[1]+'\',\''+details[2]+'\',\''+details[3]+'\', this)">';
		
			row.appendChild(td1);
			row.appendChild(td2);
			row.appendChild(td3);
			row.appendChild(td4)
			tbody.appendChild(row);
			
	}
       }
    });
	
}

function addCategory(catName_, weight_, aggr_){
	$.post('../scripts/queries/addCategory',{catName:catName_, weight:weight_, aggr:aggr_},function(data){
       if(data=="True"){
	
          var tbody = document.getElementById
		("users").getElementsByTagName('TBODY')[0];
		var row = document.createElement('TR')
	
		var td1 = document.createElement('TD')
		td1.innerHTML = catName_;
		
		var td2 = document.createElement('TD')
		td2.innerHTML = weight_;
	
		var td3 = document.createElement('TD')
		td3.innerHTML = aggr_;

		var td4 = document.createElement('TD')
		td4.innerHTML = '<img class="delete" src="pictures/delete.gif" onclick="remCategory(this)"> <img src="pictures/edit_icon.png" onclick="openUpdateCatDialog(\''+catName_+'\',\''+weight_+'\',\''+aggr_+'\', this)">';

		/*var tblHeadObj = document.getElementById('students').tHead; //table head
                	for (var h=0; h< tblHeadObj.rows.length; h++) {
                         var newTH = document.createElement('th');
                         tblHeadObj.rows[h].appendChild(newTH); //append ne th to table
                         newTH.innerHTML = catName_; //append th content to th

               }*/
		
			row.appendChild(td1);
			row.appendChild(td2);
			row.appendChild(td3);
			row.appendChild(td4);
			tbody.appendChild(row)
			
			document.getElementById("name").value = ""	
			document.getElementById("weight").value = ""
			document.getElementById("aggregation").value = ""
			alert("Successfully Added!!!")
       }else{
		alert("Failed to Add Category")
	}
    });
}

function remCategory(obj){
	val = $(obj).parent().parent().children('td').eq(0).html();
	var confirmation = confirm("Are you sure you want to delete this category?\n\n"+val)
	if(confirmation){
	$.post('../scripts/queries/remCategory',{catName:val},function(data){
       if(data.length>0){
          if(data!="True"){
		alert("Error!!!")
	}else{
		alert(val+" Successfully Removed.");
		$(obj).parent().parent().remove();
	}
       }
    });
	}
}

function openUpdateCatDialog(name_, weight, aggr, obj){
	$( "#dialog-form2" ).dialog( "open" );
	document.getElementById("origname").value = name_
	document.getElementById("name1").value = name_
	document.getElementById("weight1").value = weight
	document.getElementById("aggregation1").value = aggr
	

}

function updateCategory(name_, name1, weight_, aggr_){
	$.post('../scripts/queries/updateCategory',{name1_:name_, name2_:name1, weight:weight_, aggr:aggr_},function(data){
       if(data.length>0){
          if(data=="False"){
		alert("Error!!!")
	}else{

		
		var $tdThatContainsValue2 = $("#users tr td").filter(function(){
		    return $(this).html();
		});
		$tdThatContainsValue2.parent().children("td").eq(0).html(name1);
		$tdThatContainsValue2.parent().children("td").eq(1).html(weight_);
		$tdThatContainsValue2.parent().children("td").eq(2).html(aggr_);
		$tdThatContainsValue2.parent().children("td").eq(3).html('<img class="delete" src="pictures/delete.gif" onclick="remCategory(this)"> <img src="pictures/edit_icon.png" onclick="openUpdateCatDialog(\''+name1+'\',\''+weight_+'\',\''+aggr_+'\', this)">');
		
			}
       }
    });
	document.getElementById("origname").value = ""
	document.getElementById("name1").value = ""
	document.getElementById("weight1").value = ""
	document.getElementById("aggregation1").value = ""
	alert("Successfully Updated!")
}

function getScale(){
	 $.post('../scripts/queries/getScale',function(data){
       if(data.length>0){
          scale = data.split("@")
         for(i=0; i<scale.length-1; i++){
		details = scale[i].split("$")
		var tbody = document.getElementById
		("grdscale").getElementsByTagName('TBODY')[0];
		var row = document.createElement('TR')
	
		var td1 = document.createElement('TD')
		td1.innerHTML = '<p id="high'+details[0]+'" onclick=\'editScale("high'+details[0]+'", '+details[0]+', "high")\'>'+ details[1]+'</p>';
		
		var td2 = document.createElement('TD')
		td2.innerHTML = '<p id="low'+details[0]+'" onclick=\'editScale("low'+details[0]+'", '+details[0]+', "low")\'>'+ details[2]+'</p>';
	
		var td3 = document.createElement('TD')
		td3.innerHTML = details[3];

			row.appendChild(td1);
			row.appendChild(td2);
			row.appendChild(td3);
			tbody.appendChild(row);
		
	}
       }
    });
}


function openAddGradesDialog(grp_perf_id){


	$( "#dialog-form3" ).dialog( "open" );
	var Parent = document.getElementById("studbody");

		while(Parent.hasChildNodes())
		{
	 	  Parent.removeChild(Parent.firstChild);
		}

		getPerf(grp_perf_id)
	
}

function addGrpPerformance( description_, maxscore_, period_, date_, catId_a){
	$.post('../scripts/queries/addGrpPerformance',{ description:description_, maxscore:maxscore_, period:period_, date:date_, grdcat: catId_a},function(data){
		
       if(data.length>0){
		details = data.split("$");
          var tbody = document.getElementById
		("grpperf").getElementsByTagName('TBODY')[0];
		var row = document.createElement('TR')

		
		var td1 = document.createElement('TD')
		td1.innerHTML = details[0];
		
		var td2 = document.createElement('TD')
		td2.innerHTML = description_;
	
		var td3 = document.createElement('TD')
		td3.innerHTML = maxscore_;

		var td4 = document.createElement('TD')
		td4.innerHTML = period_;

		var td5 = document.createElement('TD')
		td5.innerHTML = date_;

		var td6 = document.createElement('TD')
		td6.innerHTML = '<img class="delete" src="pictures/delete.gif" onclick="remGrpPerf(this)"> <img src="pictures/edit_icon.png" onclick="openUpdateGradeItemDialog(\''+details[1]+'\',\''+details[2]+'\',\''+details[3]+'\',\''+details[4]+'\',\''+details[5]+'\', this)"> <img src="pictures/view.png" onclick="openAddGradesDialog(\''+details[0]+'\')"> <img src="pictures/bonus-icon.png" onclick="openAddBonusDialog()"> <img src="pictures/deduct-icon.png" onclick="openDeductBonusDialog()">';
		
			row.appendChild(td1);
			row.appendChild(td2);
			row.appendChild(td3);
			row.appendChild(td4);
			row.appendChild(td5);
			row.appendChild(td6);
			tbody.appendChild(row);
			
			//document.getElementById("grdcat").value = ""
			$('#grpPerfId').val(details[1]);	
			$("#description").val("");
			$("#maxscore").val("");
			$("#period").val("");
			$("#date").val("");
			
       }else{
		alert("Failed to Add Grade Item")
	}
	
    });
}

function getCategoryItem(){
       $.post('../scripts/queries/getCat',function(data){
     if(data.length>0){
       document.getElementById('grdcat1').innerHTML = data
     }
  });      
}

function getCategoryItem2(){
       $.post('../scripts/queries/getCat',function(data){
     if(data.length>0){

       $('#category').html(data);
     }
  });      
}

function getGrp_Perf(){
	
    $.post('../scripts/queries/getGrpPerf',function(data){
       if(data.length>0){
         var groupPerf = data.split("@")
         for(i=0; i<groupPerf.length-1; i++){
		details = groupPerf[i].split("$")

		var groupPerfId = details[0];
		var categoryName = details[1];
		var groupItemDescription = details[2];
		var maxScore = details[3];
		var pediod = details[4];
		var date = details[5];
		var categoryId = details[6];
		
		var tbody = document.getElementById
		("grpperf").getElementsByTagName('TBODY')[0];
		var row = document.createElement('TR')
		
		var td1 = document.createElement('TD')
		td1.innerHTML = categoryName;
		
		var td2 = document.createElement('TD')
		td2.innerHTML = groupItemDescription;
	
		var td3 = document.createElement('TD')
		td3.innerHTML = maxScore;

		var td4 = document.createElement('TD')
		td4.innerHTML = pediod;

		var td5 = document.createElement('TD')
		td5.innerHTML = date;

		var td6 = document.createElement('TD')
		td6.innerHTML = '<input type="hidden" id="groupItemDescription'+i+'" value="'+groupItemDescription+'" />'+
				'<img class="delete" src="pictures/delete.gif" onclick="remGrpPerf(this, \''+groupPerfId+'\', \''+i+'\')">'+
				'<img src="pictures/edit_icon.png" '+
			             'onclick="openUpdateGradeItemDialog(\''+groupPerfId+'\',\''+categoryId+'\',\''+categoryName+'\',\''+groupItemDescription+'\',\''+maxScore+'\',\''+pediod+'\',\''+date+'\')">'+
				'<img src="pictures/view.png" onclick="openAddGradesDialog(\''+groupPerfId+'\')"> <img src="pictures/bonus-icon.png" onclick="openAddBonusDialog()"> ';

		
			row.appendChild(td1);
			row.appendChild(td2);
			row.appendChild(td3);
			row.appendChild(td4);
			row.appendChild(td5);
			row.appendChild(td6);
			tbody.appendChild(row);
			
	}
       }
    });
	
}


function updateGradeItem(categoryId, categoryName, groupPerfId, grpPerfDesc, maxScore, grpPerfDate, period){
	
	$.post('../scripts/queries/updateGradeItem',
	     {grpPerfDate: grpPerfDate,
              categoryId: categoryId, 
	      groupPerfId: groupPerfId, 
              grpPerfDesc: grpPerfDesc, 
              maxScore: maxScore,  
              period: period
	     },
           function(data){
              if(data.length>0){

		
       }
    });
	
}


function openUpdateGradeItemDialog(grpPerfId, catId, categoryName, grpPerfDesc, maxScore, period, date){
	
	$("#updateGradeItemForm").dialog( "open" );
	$("#categoryName").val(categoryName);
	$("#groupPerfId").val(grpPerfId);
	$("#grpPerfDesc").val(grpPerfDesc);
	$("#category").val(catId);	
	$("#maxScore").val(maxScore);
	$("#period").val(period);
	$("#grpPerfDate").val(date);

}





function remGrpPerf(obj, groupPerfId, rowNum){
	
	var groupItemDescription = $('#groupItemDescription'+rowNum+'').val();
	var confirmation = confirm("Are you sure you want to delete this grade item?\n\n"+groupItemDescription);
	if(confirmation){
	$.post('../scripts/queries/remGrpPerf',{groupPerfId: groupPerfId},function(data){
       if(data.length>0){
          if(data!="True"){
		alert("Service is currently unavailable. Please try again later.")
	}else{
		alert("Grade Item Successfully Deleted!");
		$(obj).parent().parent().remove();
	}
       }
    });
	}
}



function getPerf(perf_id){
	
	 $.post('../scripts/queries/getPerformance',{grp_perf_id: perf_id},function(data){
       if(data.length>0){
          perf = data.split("@")
         for(i=0; i<perf.length-1; i++){
		details = perf[i].split("$")
		
		var performanceId = details[0];
		var studentId = details[1];
		var studentName = details[2];
		var score = details[3];
		var maxScore = details[4];
		var groupPrefDescription = details[5];
		
		var tbody = document.getElementById
		("studList").getElementsByTagName('TBODY')[0];
		var row = document.createElement('TR')
	
		var td1 = document.createElement('TD')
		td1.innerHTML = studentName;
		
		var td2 = document.createElement('TD')
		td2.innerHTML = studentId;

		var td3 = document.createElement('TD')
		td3.innerHTML = score;

		var td4 = document.createElement('TD')
		td4.innerHTML = '<center> <img src="pictures/edit_icon.png" onclick="openUpdatePerfDialog(\''+performanceId+'\',\''+studentId+'\',\''+studentName+'\',\''+score+'\',\''+maxScore+'\',\''+groupPrefDescription+'\',\''+perf_id+'\')"> </center>';
		
			row.appendChild(td1);
			row.appendChild(td2);
			row.appendChild(td3);
			row.appendChild(td4);
			tbody.appendChild(row);
			
	}
       }
    });
	
}


function updScale(){
	 $.post('../scripts/queries/updateScale',function(data){
      		//edit scale here!
    });
}

function getAttend(){
	 $.post('../scripts/queries/getAttend',function(data){
       if(data.length>0){
          attend = data.split("@")
         for(i=0; i<attend.length-1; i++){
		details = attend[i].split("$")
		var tbody = document.getElementById
		("attendance").getElementsByTagName('TBODY')[0];
		var row = document.createElement('TR')
	
		var td1 = document.createElement('TD')
		td1.innerHTML = details[2];
		
		var td2 = document.createElement('TD')
		td2.innerHTML = details[1];
	
		var td3 = document.createElement('TD')
		td3.innerHTML = details[3];

			row.appendChild(td1);
			row.appendChild(td2);
			row.appendChild(td3);
			tbody.appendChild(row);
		
	}
       }
    });
}





function openUpdatePerfDialog(performanceId, studentId, studentName, score, maxScore, groupPrefDescription, groupPerfId){
	
	$( "#updatePerformanceForm" ).dialog( "open" );
	$("#performanceId").val(performanceId);
	$("#groupPrefDescription").val(groupPrefDescription);
	$("#studentId").val(studentId);
	$("#studentName").val(studentName);
	$("#scoreUpdate").val(score);
	$("#maxScoreUpdate").val(maxScore);
	$("#groupPerfIdUpdate").val(groupPerfId);
}

function updatePerformance(performanceId, scoreUpdate, groupPerfIdUpdate){
	$.post('../scripts/queries/updatePerformance',{performanceId: performanceId, scoreUpdate: scoreUpdate},function(data){
       if(data.length>0 && data == "True"){
          $("#studList").find("tr:gt(0)").remove();
          getPerf(groupPerfIdUpdate);
          alert("Performance Successfully Updated.");
       }else{
	   alert("Service is currently unavailable. Please try again later.")
	}
    });

}


function getScore(){
	
	 $.post('../scripts/queries/getScore',function(data){
       if(data.length>0){
          score = data.split("@")
         for(i=0; i<score.length-1; i++){
		details = score[i].split("$")
		var tbody = document.getElementById
		("score").getElementsByTagName('TBODY')[0];
		var row = document.createElement('TR')
		
		var td1 = document.createElement('TD')
		td1.innerHTML = details[1];

		var td2 = document.createElement('TD')
		td2.innerHTML = details[0];

		var td3 = document.createElement('TD')
		td3.innerHTML = '<input type="text" size="13" id="studScore'+i+'"><input type="hidden" id="studReg'+i+'" value="'+details[2]+'"/>';


			row.appendChild(td1);
			row.appendChild(td2);
			row.appendChild(td3);
			tbody.appendChild(row);
		$('#numStudents').val(i+1);
			
	}
		
       }
		
    });
	
}



//add score!

function openAddBonusDialog(){


	$( "#bonusform" ).dialog( "open" );
	//var Parent = document.getElementById("studbody");

	//	while(Parent.hasChildNodes())
	//	{
	 //	  Parent.removeChild(Parent.firstChild);
	//	}

	//	getPerf(grp_perf_id)
	
}

function openDeductBonusDialog(){


	$( "#deductform" ).dialog( "open" );
	//var Parent = document.getElementById("studbody");

	//	while(Parent.hasChildNodes())
	//	{
	 //	  Parent.removeChild(Parent.firstChild);
	//	}

	//	getPerf(grp_perf_id)
	
}

function submitScores(){
	var numStudents = $('#numStudents').val();
	for(i=0; i<numStudents; i++){
		var regId = $('#studReg'+i).val();
		var score = $('#studScore'+i).val();
		var grpPerfId = $('#grpPerfId').val();
		$.post('../scripts/queries/addScore',{
		   grpPerfId: grpPerfId,
		   regId: regId,
		   score: score			
		}, function(data){
			
		});
	}
	alert("Successfully Added.");
}

function resetTables(){
	$("#grdscale").find("tr:gt(0)").remove();
	$("#users").find("tr:gt(0)").remove();
	$("#score").find("tr:gt(0)").remove();
	$("#studList").find("tr:gt(0)").remove();
	$("#grpperf").find("tr:gt(0)").remove();
	$("#students").find("tr:gt(0)").remove();
	$("#attendance").find("tr:gt(0)").remove();

	$("#students").find("tr:eq(0)").remove();
    	
	var tblHeadObj = document.getElementById("students").getElementsByTagName('THEAD')[0];
	   
	var row = document.createElement('TR')

	 var th0 = document.createElement('th');
	 th0.innerHTML = "Student Name";

	 var th1 = document.createElement('th');
	 th1.innerHTML = "ID Number";
	 
	 var th2 = document.createElement('th');
	 th2.innerHTML = "Grade";

	row.appendChild(th0);
	row.appendChild(th1);
	row.appendChild(th2);
	tblHeadObj.appendChild(row);
}

//for student page

function getStudentClasses(){

    checkSession()
    getStudentInfo()
	
    $.post('../scripts/queries/getStudentClasses',function(data){
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

	var td8 = document.createElement('TD')
	td8.innerHTML = details[7];	

	var td9 = document.createElement('TD')
	td9.innerHTML = '<center><input type="button" value="View" id="view_button" onclick="location.href=\'../scripts/form/section?sec='+details[1]+'&sy='+details[8]+'&subj='+details[0]+'&code='+details[9]+'\'"></center>'
	
		
		row.appendChild(td1);
		row.appendChild(td2);
		row.appendChild(td3);
		row.appendChild(td4);
		row.appendChild(td5);
		row.appendChild(td6);
		row.appendChild(td7);
		row.appendChild(td8);
		row.appendChild(td9);
		tbody.appendChild(row);             
	  }
       }
    });

}

function getStudentInfo(){

     $.post('../scripts/queries/getStudentInfo',function(data){
       if(data.length>0){
          info = data.split("$")
          var table = document.getElementById('studentInfo') 
          table.rows[1].cells[1].innerHTML = info[0]
          table.rows[2].cells[1].innerHTML = info[1]

          table.rows[0].cells[0].innerHTML = '<image src="pictures/nopic.jpg" class="r51" id="frmpic">'
       }
    });
    
}



function getHeader() {   
$.post('../scripts/queries/getHeaderReport',function(data){
	
	var jsonObject = $.parseJSON(data);	
	var tbody = document.getElementById
	("students").getElementsByTagName('TBODY')[0];
	var row = document.createElement('TR')	
	var td0 = document.createElement('TD')	
		
	row.appendChild(td0);

	$.each(jsonObject.categories, function(key, val) {
		 
               var tblHeadObj = document.getElementById('students').tHead; //table head
                 var newTH = document.createElement('th');
		 if(val.grpPerformance.length>=1){
		 	newTH.colSpan = ""+(val.grpPerformance.length+1)+""
		}
                 tblHeadObj.rows[0].appendChild(newTH); //append ne th to table
                 newTH.innerHTML = val.category+"("+val.weight+")";
		
  	});
	$.each(jsonObject.categories, function(key, val) {
		$.each(val.grpPerformance, function(key2, val2) {
			
			var td3 = document.createElement('TD')
			if(key2 < val.grpPerformance.length){			
				td3.innerHTML = val2.grpPerfName+"("+val2.items+")";
			}
			row.appendChild(td3);
			
		});
			var td4 = document.createElement('TD')
			td4.innerHTML = "<b>Total</b>";
			row.appendChild(td4);
		
	});
	tbody.appendChild(row); 
        getStudentsGrades(jsonObject);
       });
	
   }

function getStudentsGrades(jsonHeaders){
	$.post('../scripts/queries/getIndividualStudentReport', function(data){
		var grades = $.parseJSON(data);
		showStudentsGradeReport(jsonHeaders, grades);
	});
}

function showStudentsGradeReport(headings, grades){
	

	$.post('../scripts/queries/getSectionStudent',function(data){
       if(data.length>0){
          stud = data.split("@")

	for(i=0; i<stud.length-1; i++){
	     details = stud[i].split("$")
	     
		var tbody = document.getElementById
		("students").getElementsByTagName('TBODY')[0];
		var row = document.createElement('TR')
	
		
	
		
		var td4 = document.createElement('TD')
			
			

		var studGrade = null;
		$.each(grades.data, function(key1, val1){
			if(val1.student == details[0]){
				studGrade = val1;
			}
		});

		td4.innerHTML = "("+studGrade.scale+") "+(studGrade.grade*100).toFixed(2);
		row.appendChild(td4);

		$.each(headings.categories, function(key, val) {
		 	
			
			var category = null
			$.each(studGrade.categories, function(key2, val2){
				if(val.id == val2.catId){
					category = val2;				
				}		
			});
			var td6 = document.createElement('TD')
			
			if(category != null){
				$.each(category.grpPerformances, function(key3, val3){
					
					if(val3 != null){
						var td5 = document.createElement('TD')
						td5.innerHTML = val3.score
						td5.align = 'right';
						row.appendChild(td5);
					}
				});
				
				td6.innerHTML = (category.total*100).toFixed(2)
				td6.align = 'right';
				row.appendChild(td6);
			}else{
				td6.innerHTML = 0.00
				row.appendChild(td6);
			}
			
	  	});
			
			tbody.appendChild(row); 
            
	  }
       }
    });
}

