$(document).ready(function() {
	// Show all messages
	$('#message .message').each(function(i){
		$(this).animate({ top: -1 }, 500);
	});
	
	// wait 5sec and hide all messages
	setTimeout(function(){
		$('#message .message').each(function(i){
			$(this).animate({top: -$(this).outerHeight()}, 500);
		})
	},5000);
	
	// When message is clicked, hide it
	$('#message .message').click(function(){
		$(this).animate({top: -$(this).outerHeight()}, 500);
	});

	$("a[rel^='prettyPhoto']").prettyPhoto();


});