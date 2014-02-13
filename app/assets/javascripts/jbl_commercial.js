// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs 
//= require jquery-ui-1.10.2.custom.min
//= require jquery.lightbox-0.5.min
//= require jquery.datetimepicker
// require jquery.bxSlider.min
// require jwplayer
// require soundmanager2-nodebug-jsmin
// require inline_player
//= require global_functions
//= require product_tabs
//= require buy_it_now
//= require maps
//= require slideshow
//= require twitter
// require swfobject
//= require homepage
//= require foundation
//= require_self

document.createElement("article");  
document.createElement("footer");  
document.createElement("header");  
document.createElement("hgroup");  
document.createElement("nav"); 
document.createElement("section"); 

// soundManager.url = '/swfs/';
// soundManager.flashVersion = 9; // optional: shiny features (default = 8)
// soundManager.useFlashBlock = false; // optionally, enable when you're ready to dive in
// soundManager.debugMode = false;
// soundManager.preferFlash = false;

$(function(){ $(document).foundation(); });

//
// Stretchy background image
//
$(window).load(function() {    

	var theWindow        = $(window),
	    $bg              = $("#bg"),
	    aspectRatio      = $bg.width() / $bg.height();
	    			    		
	function resizeBg() {
		
		if ( (theWindow.width() / theWindow.height()) < aspectRatio ) {
		    $bg
		    	.removeClass()
		    	.addClass('bgheight');
		} else {
		    $bg
		    	.removeClass()
		    	.addClass('bgwidth');
		}
					
	}
	                   			
	theWindow.resize(resizeBg).trigger("resize");

});