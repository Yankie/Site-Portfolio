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


	//MENU ACCORDION
	$('#left .menu li a').click(function(){
		if ( $(this).hasClass('closed') ) {
			$(this).toggleClass('opened closed');
			$(this).parent().siblings().find('.sub-menu').slideUp();
			$(this).parent().siblings().find('a.opened').toggleClass('opened closed');
			$(this).next().slideDown();
			return false;	
		} else if ( $(this).hasClass('opened') ){
			$(this).toggleClass('opened closed');
			$(this).next().slideUp();
			return false;
		}
	})
	

	//SLIDER GALLERY	
	$('.slideshow').cycle({
		fx: 'fade',
		next: '#gallery-holder .navigation a.next',
		prev: '#gallery-holder .navigation a.prev'
	});
	$('.thumbnails').cycle({
		fx: 'fade',
		timeout: 0, 
		next: '#right .navigation a.next',
		prev: '#right .navigation a.prev'
	});
});