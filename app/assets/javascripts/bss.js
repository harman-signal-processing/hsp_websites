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
//= require jquery.pin
//= require jquery.rwdImageMaps.min
//= require jquery.lazyload
//= require global_functions
//= require slick
//= require where_to_find
//= require twitter
//= require homepage
//= require foundation
//= require swfobject
//= require tools
//= require math.min
//= require will_paginate_infinite
//= require bss_application
//= require network_audio
//= require configurator
//= require_self
//= require chosen-jquery
//= require enable_chosen_jquery
//= require country_state_switch
//= require product_selector

//bss.js
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

  $('.featured-slider').slick({
    slidesToShow: 3,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 4000
  });

  $('img[usemap]').rwdImageMaps();

  $("img").lazyload({
    threshold: 200,
    effect: "fadeIn"
  });

});  //  $(function(){
