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
	});
	
	var animateTime = 30,
	offsetStep = 50,
	scrollWrapper = $('#gallery .slideshow');
	
	//event handling for buttons "left", "right"
	$('#gallery .next, #gallery .prev').mousedown(function() {
		scrollWrapper.data('loop', true);
		loopingAnimation($(this), $(this).is('#gallery .next'));
	}).bind("mouseup mouseout", function() {
		scrollWrapper.data('loop', false).stop();
		$(this).data('scrollLeft', this.scrollLeft);
	});
	
	scrollWrapper.mousedown(function(event) {
		$(this).data('down', true).data('x', event.clientX).data('scrollLeft', this.scrollLeft);
		return false;
	}).mouseup(function(event) {
		$(this).data('down', false);
	}).mousemove(function(event) {
		if ($(this).data('down')) {
			this.scrollLeft = $(this).data('scrollLeft') + $(this).data('x') - event.clientX;
	}
	}).mousewheel(function(event, delta) {
		this.scrollLeft -= (delta * 90);
	}).css({
		'overflow': 'hidden',
		'cursor': '-moz-grab'
	});

	loopingAnimation = function(el, dir) {
		if (scrollWrapper.data('loop')) {
			var sign = (dir) ? offsetStep : -offsetStep;
			scrollWrapper[0].scrollLeft += sign;
			setTimeout(function() {
				loopingAnimation(el, dir);
			}, animateTime);
	}
	return false;
};
});
