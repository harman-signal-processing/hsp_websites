// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require foundation
//= require jquery.fancybox.min
//= require jquery.datetimepicker
//= require jquery.bxSlider.min
//= require jquery.pin
//= require slick
//= require global_functions
//= require product_tabs
//= require buy_it_now
//= require where_to_find
//= require slideshow
//= require tools
//= require homepage

//application.js
$(function(){
  $('.featured-slider').slick({
    slidesToShow: 3,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 4000
  });
});  //  $(function(){
