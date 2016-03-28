//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require jquery.lightbox-0.5.min
//= require jquery.bxSlider.min
//= require jquery.datetimepicker
//= require jquery.pin
//= require slick
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
//= require duran_application
//= require_self

document.createElement("article");
document.createElement("footer");
document.createElement("header");
document.createElement("hgroup");
document.createElement("nav");
document.createElement("section");

$(function(){
  $(document).foundation({
    "magellan-expedition": {
      fixed_top: 96,
      destination_threshold: 40,
    }
  });
  $('.featured-slider').slick({
    slidesToShow: 3,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 4000
  });
});
