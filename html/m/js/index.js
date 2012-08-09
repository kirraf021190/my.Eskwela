//Initialization Function... Varies on every page
$(document).bind('pageinit', function(e){
		$('div[data-role="dialog"]').live('pagebeforeshow', function(e, ui) {
			ui.prevPage.addClass("ui-dialog-background ");
		});

		$('div[data-role="dialog"]').live('pagehide', function(e, ui) {
			$(".ui-dialog-background ").removeClass("ui-dialog-background ");
		});

	
});


//External Script Function for Logout action...
function logout(){
	//var auth = new Auth(null, null); auth.logout(); 
	sessionStorage.removeItem('myEskwelaSessionUser');
	sessionStorage.removeItem('myEskwelaSessionRole');
	window.open('/eskwela.iit.edu.ph/m/components/auth/index.html', '_self');
}