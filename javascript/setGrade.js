/*function registerUser(){
	$.post('../scripts/queries/test',function(data){	
		alert(data);
	});
}*/

function setGrade(quiz, prelims, midterms, finals, attendance, others, subjectID){
	$.post('../scripts/queries/setGrade',{quiz:quiz, prelims:prelims, midterms:midterms, finals:finals, attendance:attendance, others:others, subjectID:subjectID},function(data){
		alert(data);
	});
}

