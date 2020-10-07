//= require jquery2
//= require jquery_ujs
//= require jquery-ui.min
//= require jquery.fancybox.min
//= require jquery.bxSlider.min
//= require jquery.datetimepicker
//= require jquery.pin
//= require jquery.lazyload
//= require slick
//= require global_functions
//= require where_to_find
//= require twitter
//= require homepage
//= require foundation
//= require swfobject
//= require tools
//= require tinymce-jquery
//= require tiny
//= require will_paginate_infinite
//= require duran_application
//= require_self
//= require chosen-jquery
//= require enable_chosen_jquery
//= require country_state_switch
//= require product_selector
//= require s3_direct_upload
//= require admin_upload
//= require sorting

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

  $("img").lazyload({
    threshold: 200,
    effect: "fadeIn"
  });
});

