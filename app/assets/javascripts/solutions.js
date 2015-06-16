/* Adds visible function to jQuery */
;(function(e){e.fn.visible=function(t,n,r){var i=e(this).eq(0),s=i.get(0),o=e(window),u=o.scrollTop(),a=u+o.height(),f=o.scrollLeft(),l=f+o.width(),c=i.offset().top,h=c+i.height(),p=i.offset().left,d=p+i.width(),v=t===true?h:c,m=t===true?c:h,g=t===true?d:p,y=t===true?p:d,b=n===true?s.offsetWidth*s.offsetHeight:true,r=r?r:"both";if(r==="both")return!!b&&m<=a&&v>=u&&y<=l&&g>=f;else if(r==="vertical")return!!b&&m<=a&&v>=u;else if(r==="horizontal")return!!b&&y<=l&&g>=f}})(jQuery);

/* Slide in animations */
function appear(){
	$(".fadein").each(function(index) {
		if ($(this).visible(true)) {
			$(this).children('.slideleft').each(function(i) {
				$(this).delay(250*i).css('visibility', 'visible').animate({opacity: 1.0, left: '0'}, 250);
			});
			$(this).children('.slideright').each(function(i) {
				$(this).delay(250*i).css('visibility', 'visible').animate({opacity: 1.0, right: '0'}, 250);
			});
		}
	});
}
$(window).on('scroll resize', appear);
