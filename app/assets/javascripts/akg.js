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
//= require jquery.fancybox.min
//= require jquery.datetimepicker
//= require jquery.pin
//= require jquery.rwdImageMaps.min
//= require global_functions
//= require homepage
//= require foundation
//= require tools
//= require will_paginate_infinite
//= require akg_application
//= require_self

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

