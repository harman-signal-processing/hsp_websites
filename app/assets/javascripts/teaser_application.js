//= require jquery
//= require jquery_ujs
//= require foundation

$(window).bind('scroll',function(e){
    parallaxScroll();
});

$(window).on('scroll', function(evt) {
    if($(window).scrollTop() <= 0) {
        $('.bouncing-arrow').not(':animated').fadeIn(500);
    } else {
        $('.bouncing-arrow').not(':animated').fadeOut(500);
    }
}); 

function parallaxScroll(){
	var scrolled = $(window).scrollTop();
	$('#parallax-bg1').css('top',(190-(scrolled*.35))+'px');
	$('#parallax-bg2').css('top',(480-(scrolled*.60))+'px');
	$('#parallax-bg3').css('top',(0-(scrolled*.95))+'px');
}