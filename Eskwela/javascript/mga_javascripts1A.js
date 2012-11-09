 //----------
	  

	  
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
			description = $( "#description" ),
		        maxscore = $( "#maxscore" ),
			period = $( "#period" ),
		        date = $( "#date" ),
			grade1 = $( "#grade1" ),
			maxscore1 = $( "#maxscore1" ),
			date1 = $( "#date1" ),
			period1 = $( "#period1" ),
			origgrade = $( "#origgrade" ),
			//catId_a = $("catId_a"),

			mult1 = $( "#mult1"),
			score1 = $( "#score1"),
			origscore = $("#origscore"),
			

			allFields = $( [] ).add( name ).add( weight ).add( aggregation ),
			allFields1 = $( [] ).add( grdcat ).add( description ).add( maxscore ).add( period ).add( date ),
			allFields2 = $( [] ).add( idnumber ).add( attenddate ),			
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
	width: 350,
	modal: true,
	
	});



$(function() {
		
		var $tabs = $('#tabs1').tabs();	

		$('#ui-tab-dialog-close').append($('a.ui-dialog-titlebar-close2'));

		$('.ui-dialog2').addClass('.ui-tabs')
				//.prepend($('#tabs1'))
				//.draggable('option','handle','#tabs1'); 

		$('.ui-dialog-titlebar2').remove();
		$tabs.addClass('.ui-dialog-titlebar2');

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
			
				addGrpPerformance( description.val(), maxscore.val(), period.val(), date.val());
				alert("Successfully Added!!!")

				var selected = $("#tabs1").tabs("option", "selected");
   				$("#tabs1").tabs("option", "selected", selected + 1);
				
			}

	           $tabs.tabs('select', $(this).attr("rel"));
	           return false;
	       });

});


$( "#add-grditem" )
	.button()
	.click(function() {
		
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


$( "#dialog-form5" ).dialog({
			autoOpen: false,
			height: 350,
			width: 350,
			modal: true,
			buttons: {
				"Update Grade Item": function() {
					
					var bValid = true;
					allFields.removeClass( "ui-state-error" );
					//bValid = bValid && checkLength( catId_a, "catId_a", 3, 16 );
					bValid = bValid && checkLength( grade1, "grade1", 3, 16 );
					bValid = bValid && checkLength( maxscore1, "maxscore1", 1, 3 );
					bValid = bValid && checkLength( date1, "date1", 1, 10 );
					bValid = bValid && checkLength( period1, "period1", 4, 40 );

					//bValid = bValid && checkRegexp( catId_a, /^[A-Z]([0-9a-zA-Z])+$/i, "Name may consist of a-z,A-Z, 0-9, underscores" );					
					bValid = bValid && checkRegexp( grade1, /^[A-Z]([0-9a-zA-Z])+$/i, "Name may consist of a-z,A-Z, 0-9, underscores" );
					bValid = bValid && checkRegexp( maxscore1, /^[0-9]([0-9a-z_])+$/i, "Range: 0-100" );
					bValid = bValid && checkRegexp( date, /^/i, "date1" );
					bValid = bValid && checkRegexp( period, /^[A-Z]([0-9a-zA-Z])+$/i, "Name may consist of a-z,A-Z, 0-9, underscores" );
					

					if ( bValid ) {
						//dri ma-submit ang update grade item form
						updateGradeItem(origgrade.val(), grade1.val(), maxscore1.val(), date1.val(), period1.val())
						
						$( this ).dialog( "close" );
					}
				},
				Cancel: function() {
					$( this ).dialog( "close" );
					
				}
			}
		});
		
/*------------------------view grades performance--------------*/

$( "#dialog-form3" ).dialog({
	autoOpen: false,
	height: 450,
	width: 500,
	modal: true,
	buttons: {
		"Save": function() {
			var bValid = true;
			allFields1.removeClass( "ui-state-error" );


			if ( bValid ) {
						
				//getPerf()
						 
				$( this ).dialog( "close" );
			}
			},
			Cancel: function() {
				$( this ).dialog( "close" );
			}
		}
	});


/*---------------------------Update Performance ------------------------------*/
$( "#dialog-form6" ).dialog({
			autoOpen: false,
			height: 350,
			width: 350,
			modal: true,
			buttons: {
				"Update Performance": function() {
					
					var bValid = true;
					allFields.removeClass( "ui-state-error" );

					bValid = bValid && checkLength( mult1, "mult1", 1, 3 );
					bValid = bValid && checkLength( score1, "score1", 1, 3 );
					
					bValid = bValid && checkRegexp( mult1, /^[0-9]([0-9a-z_])+$/i, "Range: 0-100" );
					bValid = bValid && checkRegexp( score1, /^[0-9]([0-9a-z_])+$/i, "Range: 0-100" );
										

					if ( bValid ) {
						//dri ma-submit ang add category form
						updatePerformance(mult1.val(), origscore.val(), score1.val())
						
						$( this ).dialog( "close" );
					}
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
	
