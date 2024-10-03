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
//= require jquery.bonsai
//= require jquery.rwdImageMaps.min
//= require slick
//= require global_functions
//= require where_to_find
//= require homepage
//= require foundation
//= require tools
//= require tinymce-jquery
//= require tiny
//= require will_paginate_infinite
//= require martin_application
//= require_self

//martin.js
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

  $("#partslist").bonsai({
    expandAll: false
  });

  $('.news-slider').slick({
    mobileFirst: true,
    slidesToShow: 1,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 4000,
    responsive: [
      {
        breakpoint: 640,
        settings: {
          slidesToShow: 2,
        }
      },
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 4,
        },
      }
    ]
  });

  $('form#filtered_news_form select#tag_filter').change(function() {
    window.location.href = $( this ).val();
  });

  $('.products-slider').slick({
    mobileFirst: true,
    slidesToShow: 1,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 6000,
    responsive: [
      {
        breakpoint: 640,
        settings: {
          slidesToShow: 2,
        }
      },
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 3,
        },
      }
    ]
  });

  $('img[usemap]').rwdImageMaps();

  $( "#market-segment-accordion" ).accordion({ collapsible: true, active: false });

});
