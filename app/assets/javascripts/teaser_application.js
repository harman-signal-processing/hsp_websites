//= require jquery
//= require jquery_ujs
//= require jquery.stickyscroll
//= require foundation

(function() {
  jQuery(function($) {
    return $('#featured-product-list ').stickyScroll({
      //container: $('#content_container_content')
    });
  });
}).call(this);

$(window).bind('scroll',function(e){
    parallaxScroll();
});

$(window).on('scroll', function(evt) {
    var scrollPos = $(window).scrollTop();
    var h1Pos = 0;
    if(scrollPos <= 0) {
        $('.bouncing-arrow').not(':animated').fadeIn(500);
        $('h1#title').css('top', '0px');
    } else if (scrollPos > 2350) {
        h1Pos = (2350 - scrollPos);
        $('h1#title').css('top', h1Pos*2 + 'px');
        //console.log(h1Pos);
    } else {
        $('.bouncing-arrow').not(':animated').fadeOut(500);
        $('h1#title').css('top', '0px');
    }

}); 

function parallaxScroll(){
	var scrolled = $(window).scrollTop();

    if (scrolled > 2000) {
        $('#parallax-bg1').fadeOut();
    } else if (scrolled <= 2000) {
        $('#parallax-bg1').fadeIn();
    }
    if (scrolled > 2250) {
        $('#parallax-bg2').fadeOut();
    } else if (scrolled <= 2250) {
        $('#parallax-bg2').fadeIn();
    }
	$('#parallax-bg1').css('top',(190-(scrolled*.35))+'px');
	$('#parallax-bg2').css('top',(480-(scrolled*.60))+'px');
	$('#parallax-bg3').css('top',(0-(scrolled*.95))+'px');
    // if (scrolled > 2200 && scrolled < 2500) {
    //     $('h1#title').css('color', '#16a66b');
    // } else if (scrolled > 1200 && scrolled < 1500) {
    //     $('h1#title').css('color', '#094ed6');
    // } else if (scrolled > 500 && scrolled < 800) {
    //     $('h1#title').css('color', '#fce32e');
    // } else if (scrolled > 2600 && scrolled < 2605) {
    //     $('h1#title').css('color', '#C1C1C1'); 
    // } else if (scrolled > 2610 && scrolled < 2615) {
    //     $('h1#title').css('color', '#f1870a');        
    // } else {
    //     $('h1#title').css('color', 'black');
    // }
}