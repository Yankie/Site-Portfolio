$(function() {
	$('#navigation').hover(
		function () {
			$('#navigation ul').stop().animate({'marginLeft':'-2px'},400);
		},
		function () {
			$('#navigation ul').stop().animate({'marginLeft':'-230px'},400);
		}
	);
	$('#gallery_info').hover(
		function () {
			$('#gallery_info > p').stop().animate({'display':'block'},400);
			$(this).stop().animate({'width':'80%'},400);
		},
		function () {
			$('#gallery_info > p').stop().animate({'display':'none'},400);
			$(this).stop().animate({'width':'10px'},400);
		}
	);
});
//MENU ACCORDION
$('#navigation .menu li a').click(function(){
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
		
$(function() {
	//current thumb's index being viewed
	var current			= -1;
	//cache some elements
	var $btn_thumbs = $('#fp_thumbtoggle');
	var $loader		= $('#fp_loading');
	var $btn_next		= $('#fp_next');
	var $btn_prev		= $('#fp_prev');
	var $thumbScroller	= $('#thumbScroller');
	
	//total number of thumbs
	var nmb_thumbs		= $thumbScroller.find('.content').length;
	
	//preload thumbs
	var cnt_thumbs 		= 0;
	for(var i=0;i<nmb_thumbs;++i){
		var $thumb = $thumbScroller.find('.content:nth-child('+parseInt(i+1)+')');
		$('<img/>').load(function(){
			++cnt_thumbs;
			if(cnt_thumbs == nmb_thumbs)
				//display the thumbs on the bottom of the page
			showThumbs(2000);
		}).attr('src',$thumb.find('img').attr('src'));
	}
	
	
	//make the document scrollable
	//when the the mouse is moved up/down
	//the user will be able to see the full image
					makeScrollable();
	
	//clicking on a thumb...
	$thumbScroller.find('.content').bind('click',function(e){
		var $content= $(this);
		var $elem 	= $content.find('img');
		//keep track of the current clicked thumb
		//it will be used for the navigation arrows
		current 	= $content.index()+1;
		//get the positions of the clicked thumb
		var pos_left 	= $elem.offset().left;
		var pos_top 	= $elem.offset().top;
		//clone the thumb and place
		//the clone on the top of it
// 		var $clone 	= $elem.clone()
// 		.addClass('clone')
// 		.css({
// 			'position':'fixed',
// 		 'left': 5 + pos_left + 'px',
// 		 'top': 5 + pos_top + 'px',
// 		 'border' : '0px'
// 		}).insertAfter($('BODY'));
		
		var windowW = $(window).width();
		var windowH = $(window).height();
		
		//animate the clone to the center of the page
// 		$clone.stop()
// 		.animate({
// 			// 						'left': windowW/2 + 'px',
// 			// 						'top': windowH/2 + 'px',
// 			// 						'margin-left' :-$clone.width()/2 -5 + 'px',
// 			// 						'margin-top': -$clone.height()/2 -5 + 'px'
// 		},500,
// 		function(){
// 			var $theClone 	= $(this);
			var ratio		= windowW/windowH;
			var final_w		= windowH;
			
			$loader.show();
			
			//expand the clone when large image is loaded
			$('<img class="fp_preview"/>').load(function(){
				var $newimg 		= $(this);
				
				var $currImage 	= $('#fp_gallery').children('img:first');
				$newimg.insertBefore($currImage);
				var newH = $(this).height();
				var newW = $(this).width();

				$loader.hide();

				
				$currImage.animate({
					'opacity'		: 0,
					'height'		: newH,
				},300, function(){
					$(this).fadeOut(300,function(){
						$(this).remove();
					});
				});
				var top = (2 * e.pageY);
				$(document).scrollTop(top);
				//expand clone
// 				$theClone.animate({
// 					'opacity'		: 0.5,
// 					'bottom'		:  + 'px',
// 					'left'			: newW/2 + 'px',
// 					'margin-top'	: -top/2-newH + 'px',
// 					'margin-left'	: -newW/2 + 'px',
// 					'height'		: newH + 'px',
// 					'width'			: newW + 'px',
// 				},2000,function(){$(this).remove();});
				
				
				//now we have two large images on the page
				//fadeOut the old one so that the new one gets shown

// 				console.log("Top = " + top + ", newH = " + newH + ", CurrH = " + $currImage.height()/2);
				//show the navigation arrows
				showNav();
			}).attr('src',$elem.attr('alt'));
// 		});
		//hide the thumbs container
		// 					hideThumbs();
// 		e.preventDefault();
	});

//clicking on the "show thumbs"
//displays the thumbs container and hides
//the navigation arrows
$btn_thumbs.bind('click',function(){
	showThumbs(500);
	hideNav();
});

function hideThumbs(){
	$('#outer_container').stop().animate({'bottom':'-160px'},500);
	showThumbsBtn();
}

function showThumbs(speed){
	$('#outer_container').stop().animate({'bottom':'0px'},speed);
	hideThumbsBtn();
}

function hideThumbsBtn(){
	$btn_thumbs.stop().animate({'bottom':'-50px'},500);
}

function showThumbsBtn(){
	$btn_thumbs.stop().animate({'bottom':'0px'},500);
}

function hideNav(){
	$btn_next.stop().animate({'right':'-50px'},500);
	$btn_prev.stop().animate({'left':'-50px'},500);
}

function showNav(){
	$btn_next.stop().animate({'right':'0px'},500);
	$btn_prev.stop().animate({'left':'0px'},500);
}
	
	//events for navigating through the set of images
	$btn_next.bind('click',showNext);
	$btn_prev.bind('click',showPrev);
	
	//the aim is to load the new image,
	//place it before the old one and fadeOut the old one
	//we use the current variable to keep track which
	//image comes next / before
	function showNext(){
		++current;
		var $e_next	= $thumbScroller.find('.content:nth-child('+current+')');
		if($e_next.length == 0){
			current = 1;
			$e_next	= $thumbScroller.find('.content:nth-child('+current+')');
		}
		$loader.show();
		$('<img class="fp_preview"/>').load(function(){
			var $newimg 		= $(this);
			var $currImage 		= $('#fp_gallery').children('img:first');
			$newimg.insertBefore($currImage);
			$loader.hide();
			$currImage.fadeOut(1000,function(){$(this).remove();});
		}).attr('src',$e_next.find('img').attr('alt'));
	}
	
	function showPrev(){
		--current;
		var $e_next	= $thumbScroller.find('.content:nth-child('+current+')');
		if($e_next.length == 0){
			current = nmb_thumbs;
			$e_next	= $thumbScroller.find('.content:nth-child('+current+')');
		}
		$loader.show();
		$('<img class="fp_preview"/>').load(function(){
			var $newimg 		= $(this);
			var $currImage 		= $('#fp_gallery').children('img:first');
			$newimg.insertBefore($currImage);
			$loader.hide();
			$currImage.fadeOut(2000,function(){$(this).remove();});
		}).attr('src',$e_next.find('img').attr('alt'));
	}
	
	function makeScrollable(){
		$(document).bind('mousemove',function(e){
			var top = e.pageY - $(document).scrollTop();
// 			console.log("Top = " + top + ", Y = " + e.pageY + ", Wh = " + $(window).height() + ", Dh = " + $(document).height());
			$(document).scrollTop(top);
		});
	}
});
	