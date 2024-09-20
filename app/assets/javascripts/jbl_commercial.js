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
//= require jquery2
//= require jquery_ujs
//= require jquery-ui.min
//= require jquery.fancybox.min
//= require jquery.datetimepicker
//= require jquery.rwdImageMaps.min
//= require global_functions
//= require buy_it_now
//= require where_to_find
//= require twitter
//= require homepage
//= require foundation
//= require will_paginate_infinite
//= require tools
//= require tinymce-jquery
//= require tiny
//= require chosen-jquery
//= require enable_chosen_jquery
//= require product_selector
//= require s3_direct_upload
//= require admin_upload
//= require sorting
//= require_self

// soundManager.url = '/swfs/';
// soundManager.flashVersion = 9; // optional: shiny features (default = 8)
// soundManager.useFlashBlock = false; // optionally, enable when you're ready to dive in
// soundManager.debugMode = false;
// soundManager.preferFlash = false;

$(function(){
  $(document).foundation({
    "magellan-expedition": {
      fixed_top: 44,
      destination_threshold: 40,
    },
    equalizer: {
      equalize_on_stack: true
    }
  });

  $('img[usemap]').rwdImageMaps();

});

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
