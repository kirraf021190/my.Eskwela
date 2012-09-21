var popupStatus = 0;

function loadPopup(){

	if(popupStatus==0){
		$("#background").css({
			"opacity": "0.7"
		});
		$("#background").fadeIn("slow");
		$("#popup").fadeIn("slow");
		popupStatus = 1;
	}
}

function disablePopup(){

	if(popupStatus==1){
		$("#background").fadeOut("slow");
		$("#popup").fadeOut("slow");
		popupStatus = 0;
	}
}

function centerPopup(){

	var windowWidth = document.documentElement.clientWidth;
	var windowHeight = document.documentElement.clientHeight;
	var popupHeight = $("#popup").height();
	var popupWidth = $("#popup").width();

	$("#popup").css({
		"position": "absolute",
		"top": windowHeight/2-popupHeight/2,
		"left": windowWidth/2-popupWidth/2
	});

	
	$("#background").css({
		"height": windowHeight
	});
	
}

$(document).ready(function(){
	
	$("#button").click(function(){
		centerPopup();
		loadPopup();
	});
				

	$("#popupClose").click(function(){
		disablePopup();
	});

	$("#background").click(function(){
		disablePopup();
	});

	$(document).keypress(function(e){
		if(e.keyCode==27 && popupStatus==1){
			disablePopup();
		}
	});

});
