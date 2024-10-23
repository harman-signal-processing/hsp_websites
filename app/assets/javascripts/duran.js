//= require jquery.fancybox.min
//= require jquery.datetimepicker
//= require jquery.pin
//= require slick
//= require global_functions
//= require foundation
//= require tools
//= require will_paginate_infinite
//= require duran_application
//= require_self

$(function(){
  $(document).foundation({
    "magellan-expedition": {
      fixed_top: 96,
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

});

