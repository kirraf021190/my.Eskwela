 //----------
	  
	var loadTab0 = function(){
		resetTables();
		checkSession();
		getScale();
	}
	
	var loadTab1 = function(){
		resetTables();
		checkSession();
		getCategories();
	}
	
	var loadTab2 = function(){
		resetTables();
		checkSession();
		getGrp_Perf();
		getCategoryItem();
		getCategoryItem2();
	}

	var loadTab3 = function(){
		resetTables();
		checkSession();
		getHeader();
	}

	var loadTab4 = function(){
		resetTables();
		checkSession();
		getAttend();
	}

	  
   jQuery.extend({
        getValues: function(url)
           { //+++
	     var result = null;
	     $.ajax({
		url:url,
                type: 'get', 
                dataType:'text',
                async:false,
                success: function(data){
                     result = data;
                  
                   }
		//error: function () {}
              });//ajax
	      return result;
           } //+++
    }); //extend          
  //usage:
  //var results = $.getValues("url string");
  //----------
  
    
 $(document).ready(function() {
      $("input#sections").autocomplete({
       source: ["CENG1","CENG2"] 
     }); //autocomplete
    
     $("button").button(); //button
   
     $("#tabs").tabs(); //tabs
     $("#radio").buttonset(); //radio
   
	$("#00").click(function(){
		loadTab0();
	});
	$("#01").click(function(){
		loadTab1();
	});
	$("#02").click(function(){
		loadTab2();
	});
	$("#03").click(function(){
		loadTab3();
	});
	$("#04").click(function(){
		loadTab4();
	});

	
		         


             
		}); //document on ready

		
		 
		 
/* ----------------------  SUBMIT FUNCTION ----------------------------- */	

$(function() {
	$( "input:submit", ".button" ).button();
});



/* ------------------------------ RUN EFFECT --------------------------- */

$(function() {
	// run the currently selected effect
	function runEffect() {
		// get effect type from 
		var selectedEffect = $( "#effectTypes" ).val();
		
		// most effect types need no options passed by default
		var options = {};
		// some effects have required parameters
		if ( selectedEffect === "scale" ) {
			options = { percent: 0 };
		} else if ( selectedEffect === "size" ) {
			options = { to: { width: 200, height: 60 } };
		}
		
		// run the effect
		$( "#effect" ).toggle( selectedEffect, options, 500 );
	};
	
	// set effect from select menu value
	$( "#button" ).click(function() {
		alert("submitted!")
		runEffect();
		return false;
	});
});



/* ------------------------- FOR DIALOG-FORM -------------------------------- */

$(function() {
		$( "#dialog:ui-dialog" ).dialog( "destroy" );
		var submitted = false;
		var name = $( "#name" ),
			weight = $( "#weight" ),
			aggregation = $( "#aggregation" ),
		        name1 = $( "#name1" ),
			weight1 = $( "#weight1" ),
			origname = $("#origname")
			aggregation1 = $( "#aggregation1" ),
			
			idnumber = $( "#idnumber" ),
			attenddate = $( "#attenddate" ),

			
			grdcat = $( "#grdcat" ),
			grdcat1 = $( "#grdcat1" ),
			description = $( "#description" ),
		        maxscore = $( "#maxscore" ),
			period = $( "#period" ),
		        date = $( "#date" ),
			grpItemDesc = $( "#grpItemDesc" ),
			maxScore = $( "#maxScore" ),
			date1 = $( "#date1" ),
			period1 = $( "#period1" ),
			origgrade = $( "#origgrade" ),
			//catId_a = $("catId_a"),

			mult1 = $( "#mult1"),
			score1 = $( "#score1"),
			origscore = $( "#origscore"),
			
			idnum = $( "#idnum"),
			student =$( "#student"),
			bScore =$( "#bScore"),
			dScore =$( "#dScore"),

			allFields = $( [] ).add( name ).add( weight ).add( aggregation ),
			allFields1 = $( [] ).add( grdcat ).add( description ).add( maxscore ).add( period ).add( date ),
			allFields2 = $( [] ).add( idnumber ).add( attenddate ),		
			allFields3 = $( [] ).add( idnum ).add( student ).add( bScore ),	
			allFields4 = $( [] ).add( idnum ).add( student ).add( dScore ),				
			tips = $( ".validateTips" );

		function updateTips( t ) {
			tips
				.text( t )
				.addClass( "ui-state-highlight" );
			setTimeout(function() {
				tips.removeClass( "ui-state-highlight", 1500 );
			}, 500 );
		}

		function checkLength( o, n, min, max ) {
			if ( o.val().length > max || o.val().length < min ) {
				o.addClass( "ui-state-error" );
				updateTips( "Length of " + n + " must be between " +
					min + " and " + max + "." );
				return false;
			} else {
				return true;
			}
		}

		function checkRegexp( o, regexp, n ) {
			if ( !( regexp.test( o.val() ) ) ) {
				o.addClass( "ui-state-error" );
				updateTips( n );
				return false;
			} else {
				return true;
			}
		}
		
		$( "#dialog-form" ).dialog({
			autoOpen: false,
			height: 350,
			width: 350,
			modal: true,
			buttons: {
				"Add Category": function() {
					var bValid = true;
					allFields.removeClass( "ui-state-error" );

					bValid = bValid && checkLength( name, "name", 3, 16 );
					
					bValid = bValid && checkLength( weight, "weight", 1, 3 );
					bValid = bValid && checkLength( aggregation, "aggregation", 4, 40 );

					bValid = bValid && checkRegexp( name, /^[A-Z]([0-9a-zA-Z])+$/i, "Name may consist of a-z,A-Z, 0-9, underscores" );
					bValid = bValid && checkRegexp( weight, /^[0-9]([0-9a-z_])+$/i, "Range: 0-100" );
					bValid = bValid && checkRegexp( aggregation, /^/i, "Aggregation of Grades" );
					

					if ( bValid ) {
						//dri ma-submit ang add category form
							
						addCategory(name.val(), weight.val(), aggregation.val())
						 
						$( this ).dialog( "close" );
					}
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			}
		});

		$( "#add-cat" )
			
			.button()
			
			.click(function() {
			
				$( "#dialog-form" ).dialog( "open" );
			});

/*---------------------------Update category ------------------------------*/


$( "#dialog-form2" ).dialog({
			autoOpen: false,
			height: 350,
			width: 350,
			modal: true,
			buttons: {
				"Update Category": function() {
					
					var bValid = true;
					allFields.removeClass( "ui-state-error" );

					bValid = bValid && checkLength( name1, "name1", 3, 16 );
					bValid = bValid && checkLength( weight1, "weight1", 1, 3 );
					bValid = bValid && checkLength( aggregation1, "aggregation1", 4, 40 );

					bValid = bValid && checkRegexp( name1, /^[A-Z]([0-9a-zA-Z])+$/i, "Name may consist of a-z,A-Z, 0-9, underscores" );
					bValid = bValid && checkRegexp( weight1, /^[0-9]([0-9a-z_])+$/i, "Range: 0-100" );
					bValid = bValid && checkRegexp( aggregation1, /^/i, "Aggregation of Grades" );
					

					if ( bValid ) {
						//dri ma-submit ang add category form
						updateCategory(origname.val(), name1.val(), weight1.val(), aggregation1.val())
						
						$( this ).dialog( "close" );
					}
				},
				Cancel: function() {
					$( this ).dialog( "close" );
					
				}
			}
		});
/*-------------------------dialog-form1--------------------------------*/

$( "#dialog-form1" ).dialog({
	
	autoOpen: false,
	height: 500,
	width: 650,
	modal: true,
	
	});



$(function() {
		
		var $tabs = $('#tabs1').tabs();	
		
		$('#ui-tab-dialog-close').append($('a.ui-dialog-titlebar-close2'));

		$('.ui-dialog2').addClass('.ui-tabs')
				//.prepend($('#tabs1'))
				.draggable('option','handle','#tabs1'); 

		$('.ui-dialog-titlebar2').remove();
		$tabs.addClass('.ui-dialog-titlebar2');

		$("#tabs1").tabs({disabled: [0,1]});

		$('#add_item').click(function() { 
			var bValid = true;
			allFields1.removeClass( "ui-state-error" );

			//bValid = bValid && checkLength( grdcat, "grdcat", 3, 16 );
			bValid = bValid && checkLength( description, "description", 1, 20 );
			bValid = bValid && checkLength( maxscore, "maxscore", 1, 10 );
			bValid = bValid && checkLength( period, "period", 1, 10 );
			bValid = bValid && checkLength( date, "date", 1, 10 );

			//bValid = bValid && checkRegexp( grdcat, /^[A-Z]([0-9a-zA-Z])+$/i, "Name may consist of a-z,A-Z, 0-9, underscores" );
			bValid = bValid && checkRegexp( description, /^[A-Z]([0-9a-zA-Z])+$/i, "Range: 0-100" );
			bValid = bValid && checkRegexp( maxscore, /^([0-9])+$/i, "Range 0-100" );
			bValid = bValid && checkRegexp( period, /^[A-Z]([0-9a-zA-Z])+$/i, "Name may consist of a-z,A-Z, 0-9, underscores" );
			bValid = bValid && checkRegexp( date, /^/i, "Date" );


			if ( bValid ) {
				
				addGrpPerformance( description.val(), maxscore.val(), period.val(), date.val(), grdcat1.val());

				
				$("#tabs1").tabs({disabled: [0]});
							
				var selected = $("#tabs1").tabs("option", "selected");
   				$("#tabs1").tabs("option", "selected", selected + 1);

				$("#tabs1").tabs({disabled: [0]});

				$('#add_score').button().click(function() {

					if ( bValid ) {
						submitScores();
						$("#dialog-form1").dialog( "close" );
						//$( this ).dialog( "close" );
						var $tabs = jQuery("#tabs > ul").tabs( { selected: null } );
						$tabs.tabs("select", 2);
						loadTab2();
						$("#tabs1").tabs({disabled: false});	
   						$("#tabs1").tabs('select',0);
						$("#tabs1").tabs({disabled: [0,1]});
					}
				    
				});		    
			}

	           $tabs.tabs('select', $(this).attr("rel"));
	           return false;

	       });


});


$( "#add-grditem" )
	.button()
	.click(function() {
		getScore();
		$( "#dialog-form1" ).dialog( "open" );
		getCat();
		
	});


/*------------------------- TABS1 --------------------------------------------------

$(function() {

			var $tabs = $('#tabs1').tabs();
	
			$(".ui-tabs-panel2").each(function(i){
	
			  var totalSize = $(".ui-tabs-panel2").size() - 1;
	
			  if (i != totalSize) {
			      next = i + 2;
		   		  $(this).append("<button id='add-grditem' class='ui-widget'>Add Grade Item</button> <a href='#' class='next-tab2 mover' rel='" + next + "'>Next &#187;</a>");
			  }
	  
			  if (i != 0) {
			      prev = i;
		   		  $(this).append("<a href='#' class='prev-tab2 mover' rel='" + prev + "'>&#171; Prev Page</a>");
			  }
   		
			});
	
			$('.next-tab2, .prev-tab2').click(function() { 
		           $tabs.tabs('select', $(this).attr("rel"));
		           return false;
		       });
       

		});

--*/

/*---$('#tabs1').tabs();
$(function() {

			var $tabs = $('#tabs1').tabs();

	
			$(".ui-tabs-panel2").each(function(i){
	
			  var totalSize = $(".ui-tabs-panel2").size() - 1;

	
			  if (i != totalSize) {
			      next = i + 2;

		   		  $(this).append("<a href='#' class='next-tab2 mover' rel='" + next + "'>Next Page &#187;</a>");
			  }
	  

			  if (i != 0) {
			      prev = i;
		   		  $(this).append("<a href='#' class='prev-tab2 mover' rel='" + prev + "'>&#171; Prev Page</a>");

			  }
   		
			});
	

			$('.next-tab2, .prev-tab2').click(function() { 
		           $tabs.tabs('select', $(this).attr("rel"));
		           return false;

		       });
       

		});
$('#dialog-form1').dialog({ 'modal':true, 
                       'width':400, 'height':300,  
                       'draggable':true });

$('#ui-tab-dialog-close').append($('a.ui-dialog-titlebar-close'));

$('.ui-dialog').addClass('ui-tabs')
                .prepend($j('#tabs1'))
                .draggable('option','handle','#tabs1'); 

$('.ui-dialog-titlebar').remove();
$('#tabs1').addClass('ui-dialog-titlebar');


/*---------------------------Update Grade Item ------------------------------*/


$( "#updateGradeItemForm" ).dialog({
	autoOpen: false,
	height: 470,
	width: 350,
	modal: true,
	buttons: {
	    "Update Grade Item": function() {
	
	        var bValid = true;
		allFields.removeClass( "ui-state-error" );
		
		var groupPerfId = $('#groupPerfId').val();
		var categoryId = $('#category').val();
 		var categoryName = $('#categoryName').val();
		var grpPerfDesc = $('#grpPerfDesc').val();
		var maxScore = $('#maxScore').val();
		var grpPerfDate = $('#grpPerfDate').val();
		var period = $('#period').val();

		updateGradeItem(categoryId, categoryName, groupPerfId, grpPerfDesc, maxScore, grpPerfDate, period);
			
		$( this ).dialog( "close" );
		var $tabs = jQuery("#tabs > ul").tabs( { selected: null } );
		$tabs.tabs("select", 2);
		loadTab2();
		alert("Grade Item Successfully Updated.");
		
	},
	Cancel: function() {
		$( this ).dialog( "close" );
		
	}
	}
});
		

/*--------------------- Bonus form --------------------------*/


$( "#bonusform" ).dialog({
	
	autoOpen: false,
	height: 350,
	width: 350,
	modal: true,
	buttons: {
		
		"Add Bonus": function() {
			
			var bValid = true;
			allFields2.removeClass( "ui-state-error" );

			bValid = bValid && checkLength( idnum, "idnum", 1, 10 );
			bValid = bValid && checkLength( student, "student", 1, 10 );
			bValid = bValid && checkLength( bScore, "bScore", 1, 10 );
		
			bValid = bValid && checkRegexp( idnum, /^[A-Z]([0-9a-zA-Z])+$/i, "Range: 0-100" );
			bValid = bValid && checkRegexp( student, /^[A-Z]([0-9a-zA-Z])+$/i, "Range: 0-100" );
			bValid = bValid && checkRegexp( bScore, /^([0-9])+$/i, "Range 0-100" );
			

			if ( bValid ) {
					
				//addAttendance( idnumber.val(), studname.val(), attenddate.val(), attendcount.val())
						 
				$( this ).dialog( "close" );
			}
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});
	
/*--------------------------end ------------------------*/

/*--------------------- Bonus form --------------------------*/


$( "#deductform" ).dialog({
	
	autoOpen: false,
	height: 350,
	width: 350,
	modal: true,
	buttons: {
		
		"Deduct": function() {
			
			var bValid = true;
			allFields2.removeClass( "ui-state-error" );

			bValid = bValid && checkLength( idnum, "idnum", 1, 10 );
			bValid = bValid && checkLength( student, "student", 1, 10 );
			bValid = bValid && checkLength( dScore, "dScore", 1, 10 );
		
			bValid = bValid && checkRegexp( idnum, /^[A-Z]([0-9a-zA-Z])+$/i, "Range: 0-100" );
			bValid = bValid && checkRegexp( student, /^[A-Z]([0-9a-zA-Z])+$/i, "Range: 0-100" );
			bValid = bValid && checkRegexp( gradeitem, /^[A-Z]([0-9a-zA-Z])+$/i, "Range: 0-100");			
			bValid = bValid && checkRegexp( dScore, /^([0-9])+$/i, "Range 0-100" );
			

			if ( bValid ) {
					
				//addAttendance( idnumber.val(), studname.val(), attenddate.val(), attendcount.val())
						 
				$( this ).dialog( "close" );
			}
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});
	
/*--------------------------end ------------------------*/


/*------------------------view grades performance--------------*/

$( "#dialog-form3" ).dialog({
	autoOpen: false,
	height: 450,
	width: 500,
	modal: true,
	buttons: {
		//"Save": function() {
		//	var bValid = true;
		//	allFields1.removeClass( "ui-state-error" );


		//	if ( bValid ) {
						
				//getPerf()
						 
		//		$( this ).dialog( "close" );
		//		}
		//	},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});


/*---------------------------Update Performance ------------------------------*/
$( "#updatePerformanceForm" ).dialog({
	autoOpen: false,
	height: 490,
	width: 350,
	modal: true,
	buttons: {
		"Update Performance": function() {
		    
                   var performanceId = $("#performanceId").val();
	           var scoreUpdate = $("#scoreUpdate").val();
	           var groupPerfIdUpdate = $("#groupPerfIdUpdate").val();
		   updatePerformance(performanceId, scoreUpdate, groupPerfIdUpdate);
		   $( this ).dialog( "close" );	
		},
		Cancel: function() {
			$( this ).dialog( "close" );
			
		}
	}
});

/*--------------------- attendance form --------------------------*/


$( "#attendanceform" ).dialog({
	
	autoOpen: false,
	height: 400,
	width: 300,
	modal: true,
	buttons: {
		
		"Save": function() {
			
			var bValid = true;
			allFields2.removeClass( "ui-state-error" );

			bValid = bValid && checkLength( idnumber, "idnumber", 1, 10 );
			bValid = bValid && checkLength( attenddate, "studname", 1, 10 );
			bValid = bValid && checkLength( attenddate, "attenddate", 1, 10 );
			bValid = bValid && checkLength( attenddate, "attendcount", 1, 10 );
		
			bValid = bValid && checkRegexp( idnumber, /^[A-Z]([0-9a-zA-Z])+$/i, "Range: 0-100" );
			bValid = bValid && checkRegexp( studname, /^[A-Z]([0-9a-zA-Z])+$/i, "Range: 0-100" );
			bValid = bValid && checkRegexp( attenddate, /^/i, "Date" );			
			bValid = bValid && checkRegexp( idnumber, /^([0-9])+$/i, "Range 0-100" );
			

			if ( bValid ) {
					
				addAttendance( idnumber.val(), studname.val(), attenddate.val(), attendcount.val())
						 
				$( this ).dialog( "close" );
			}
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});

$( "#attendance-form" )
	.button()
	.click(function() {
		
		$( "#attendanceform" ).dialog( "open" );
		
	});

	
/*--------------------------end ------------------------*/

	});




/* -------------------------- DATE PICKER -------------------------------- */

$(function() {

		$( "#date" ).datepicker();

	});

/* -------------------------- DATE PICKER for Grade Item -------------------------------- */

$(function() {

		$( "#date1" ).datepicker();

	});


/* -------------------------- DATE PICKER FOR ATTENDANCE-------------------------------- */

$(function() {

		$( "#attenddate" ).datepicker();

	});


/*-------------------------------------------------------*/

$("#editme").editInPlace({
		callback: function(original_element, html, original){
			$("#updateDiv1").html("The original html was: " + original);
			$("#updateDiv2").html("The updated text is: " + html);
			return(html);
		}
	});


	
