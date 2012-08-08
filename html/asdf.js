$(function(){
  $("#tp").click(function () {
      alert('asdf');
    });



  $( "#resetpass" )
   .click(function() {
		
		$( "#resetpassform" ).dialog("open");
		//alert('asdf');
		
	});
	$( "#resetpassform" ).dialog({
	
	autoOpen: false,
	height: 300,
	width: 270,
	modal: true,
	buttons: {
		
			"Save": function() {
			 match = true;
			 if($("#newpass").val() != $("#newpassconf").val())
		 	 	alert("doesn't match");
		 	 else
		 	    changepass($("#newpass").val(), $("#oldpass").val());
		 	 	$(this).dialog("close");
			},
			"Cancel": function() {
			$( this ).dialog( "close" );
			}
		}
	});
});