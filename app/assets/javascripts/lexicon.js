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
//= require jquery-ui.min
//= require jquery.lightbox-0.5.min
//= require jquery.bxSlider.min
//= require jquery.datetimepicker
//= require jquery.pin
//= require jquery.rwdImageMaps.min
//= require slick
//= require soundmanager2-nodebug-jsmin
//= require inline_player
//= require global_functions
//= require maps
//= require twitter
//= require homepage
//= require foundation
//= require lightbox
// require add2home
//= require jwplayer
//= require swfobject
//= require tools
//= require will_paginate_infinite
//= require lexicon_application
//= require_self
//= require chosen-jquery

soundManager.url = '/swfs/';
soundManager.flashVersion = 9; // optional: shiny features (default = 8)
soundManager.useFlashBlock = false; // optionally, enable when you're ready to dive in
soundManager.debugMode = false;
soundManager.preferFlash = false;

$(function(){
  $(document).foundation({
    "magellan-expedition": {
      fixed_top: 80,
      destination_threshold: 40,
    },
    equalizer: {
      equalize_on_stack: true
    }
  });

  $('.featured-slider').slick({
    slidesToShow: 3,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 4000
  });

  $('img[usemap]').rwdImageMaps();
  
  /*used in /support area of brand sites */
  $('#country-switch').change(function(e){
    var $this = $(this),
        country_code = $this.val();
    location.search = 'geo=' + country_code.toLowerCase();
  });

   // enable chosen js
  $('.chosen-select').chosen(
  	{
    	allow_single_deselect: true,
    	no_results_text: 'No results matched',
    	width: '100%'
    }); 
  
});  //  $(function(){

