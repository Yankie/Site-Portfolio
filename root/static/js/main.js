$(document).ready(function() {

	//prettyPhoto LIGHTBOX
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
});