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
//= require jquery.cookie
//= require slick
//= require global_functions
//= require where_to_find
//= require homepage
//= require foundation
//= require tools
//= require tinymce-jquery
//= require tiny
//= require will_paginate_infinite
//= require amx_application
//= require network_audio
//= require_self

//amx.js
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
    slidesToShow: 4,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 4000
  });

  $('img[usemap]').rwdImageMaps();

  /*used on /vip_programmers*/
  $("#vipOtherFiltersToggleSwitch").click(function() {
      $this = $(this);
      $("#vipOtherFilters").fadeToggle();
      //$this.html() == "Hide extra filters" ? $this.html('Show more filters') : $this.html('Hide extra filters');
      var filterAreShowing = $this.html() == "Hide extra filters";
      filterAreShowing ? filtersShowing($this) : filtersNotShowing($this);

      function filtersShowing($this)
      {
        //This will update the text after the toggle has happened. To read it seems backwards but this works.
        $this.html('Show more filters');
        $.removeCookie("show_all_vip_filters");
      }
      function filtersNotShowing($this)
      {
        $this.html('Hide extra filters');
        //set showfilters cookie
        $.cookie("show_all_vip_filters", 1);
      }
  });

});  //  $(function(){

