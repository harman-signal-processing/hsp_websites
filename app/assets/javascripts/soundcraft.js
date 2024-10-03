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
//= require muse/jquery-1.8.3.min
//= require jquery-ui.min
//= require jquery.datetimepicker
//= require jquery.pin
//= require jquery.rwdImageMaps.min
//= require jquery.cookie
//= require global_functions
//= require slick
//= require where_to_find
//= require homepage
//= require foundation
//= require will_paginate_infinite
//= require soundcraft_application
//= require tools
//= require tinymce-jquery
//= require tiny
//= require_self

/* vendor/jquery.js (v2) doesn't work with Muse scrolling so downgraded to muse/jquery-1.8.3.min.js 30/12/2014 */

//soundcraft.js
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

});  //  $(function(){

