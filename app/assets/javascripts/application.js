// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery.min
//= require jquery_ujs 
//= require jquery-ui-1.8.16.custom.min
//= require jquery.lightbox-0.5.min
//= require jquery.datetimepicker
//= require ui.coverflow
//= require swfobject
//= require jwplayer
//= require soundmanager2-nodebug-jsmin
//= require inline_player
//= require global_functions
//= require product_tabs

soundManager.url = '/swfs/';
soundManager.flashVersion = 9; // optional: shiny features (default = 8)
soundManager.useFlashBlock = false; // optionally, enable when you're ready to dive in
soundManager.debugMode = false;
soundManager.preferFlash = false;

function start_slideshow(start_frame, end_frame, delay, transition) {
 	slideshow_controller = setTimeout(switch_slides(start_frame,start_frame,end_frame, delay, transition), delay);
	current_frame_controller = setTimeout("", delay);
	next_frame_controller = setTimeout("", delay);
}
                     
function switch_slides(frame, start_frame, end_frame, delay, transition) {
 return (function() {
	if (transition != "toggle") { transition = "fadeOut"; }
	 eval("$('#slideshow_" + frame +"')." + transition + "();");
	 $('#slideshow_control_' + frame).removeClass('current_button');
     if (frame == end_frame) { frame = start_frame; } else { frame = frame + 1; }
     next_frame_controller = setTimeout(switch_slides(frame, start_frame, end_frame, delay, transition), delay + 850);
     if (transition != "toggle") { transition = "fadeIn"; }
     current_frame_controller = setTimeout("$('#slideshow_" + frame + "')." + transition + "();$('#slideshow_control_" + frame +"').addClass('current_button');", 175);
 })
}

function stop_slideshow(stop_on, last_frame) {
	if (slideshow_controller)
		clearTimeout(slideshow_controller);
	if (current_frame_controller)
		clearTimeout(current_frame_controller);
	if (next_frame_controller)
		clearTimeout(next_frame_controller);
	for (var i=1; i<=last_frame; i++) {
		$('#slideshow_' + i).hide();
		$('#slideshow_control_' + i).removeClass('current_button');
	}
	$('#slideshow_' + stop_on).show();
	$('#slideshow_control_' + stop_on).addClass('current_button');
}

function blanket_size(popUpDivVar) {
	blanket_height = window.innerHeight || (window.document.documentElement.clientHeight || window.document.body.clientHeight);
	$('#blanket').css('height', blanket_height + 'px');
	popUpDiv_height = 120 //blanket_height/2-150;//150 is half popup's height
	$('#' + popUpDivVar).css('top', popUpDiv_height + 'px');
	$('#' + popUpDivVar + '_close').css('top', (popUpDiv_height - 16) + 'px');
}
function window_pos(popUpDivVar) {
	window_width = window.innerWidth || (window.document.documentElement.clientWidth || window.document.body.clientWidth);
	$('#' + popUpDivVar).css('left', (window_width/2-370) + 'px');
	$('#' + popUpDivVar + '_close').css('right', (window_width/2-418) + 'px');
}
function popup(windowname) {
	blanket_size(windowname);
	window_pos(windowname);
	$('#blanket').toggle();
	$('#' + windowname).toggle();
	$('#' + windowname + '_close').toggle();	
}

// twitter popups
(function() {
  var intentRegex = /twitter\.com(\:\d{2,4})?\/intent\/(\w+)/,
      shortIntents = { tweet: true, retweet:true, favorite:true },
      windowOptions = 'scrollbars=yes,resizable=yes,toolbar=no,location=yes',
      winHeight = screen.height,
      winWidth = screen.width;

  function handleIntent(e) {
    e = e || window.event;
    var target = e.target || e.srcElement,
        m, width, height, left, top;

    while (target && target.nodeName.toLowerCase() !== 'a') {
      target = target.parentNode;
    }

    if (target && target.nodeName.toLowerCase() === 'a' && target.href) {
      m = target.href.match(intentRegex);
      if (m) {
        width = 550;
        height = (m[2] in shortIntents) ? 420 : 560;

        left = Math.round((winWidth / 2) - (width / 2));
        top = 0;

        if (winHeight > height) {
          top = Math.round((winHeight / 2) - (height / 2));
        }

        window.open(target.href, 'intent', windowOptions + ',width=' + width + ',height=' + height + ',left=' + left + ',top=' + top);
        e.returnValue = false;
        e.preventDefault && e.preventDefault();
      }
    }
  }

  if (document.addEventListener) {
    document.addEventListener('click', handleIntent, false);
  } else if (document.attachEvent) {
    document.attachEvent('onclick', handleIntent);
  }
}());

// maps borrowed from TheBigFork.com
var markerHash = {};
var markersArray = [];
var letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; // sure, not elegant, but it works.
var map;
var currentFocus = false;
var browserSupportFlag = new Boolean();
var initialLocation;

function map_init(lat, lng, zoom, no_drag) {
	var latlng = new google.maps.LatLng(lat, lng);
	var map = new google.maps.Map(document.getElementById('map'), {
		zoom: zoom,
		center: latlng,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	});
	load_markers(map,markers_json);
	window.map = map;
}

function load_markers(map,markers) {
    for (var i = 0 ; i < markers.length ; i++) {
        var marker = markers[i]["dealer"];
        var lat = marker.lat;
        var lng = marker.lng;
        if (lat && lng) {
            var innerHtml = '<div class="marker_info"><b style="font-size: 13px">'
				     + marker.name 
					 + '</b><br/>'
                     + marker.address + '<br/>'
                     + marker.city + ', ' + marker.state + ' ' + marker.zip + '<br/>'
					 + marker.telephone
                     + '</div>';
            var mymarker = addMarker(map,parseFloat(lat),parseFloat(lng),innerHtml,(i + 1));
			markersArray.push(mymarker);
            markerHash[(i + 1)] = {marker:mymarker,address:innerHtml};
        } // end of if lat and lng
    } // end of for loop
}

function addMarker(map, lat, lng, description, id) {
	var myLatLng = new google.maps.LatLng(lat, lng);
    var marker = new google.maps.Marker({
		position: myLatLng,
		map: map,
		animation: google.maps.Animation.DROP
		});
	if (description != '') {
		google.maps.event.addListener(marker, 'click', function() {
			new google.maps.InfoWindow({
				content: description
			}).open(map,marker);
			focusSideBar(id);
		})
	}
    return marker;
}

function focusPoint(id){
	focusSideBar(id);
	new google.maps.InfoWindow({
		content: markerHash[id].address
	}).open(map,markerHash[id].marker);
}

function focusSideBar(id){
	if (currentFocus) {
		$("sidebar-item-"+currentFocus).removeClassName("current");
	}
	$("sidebar-item-"+id).addClassName("current");
	currentFocus = id;
}

function clearOverlays() {
	if (markersArray) {
	    for(var i=0; i < markersArray.length; i++){
	        markersArray[i].setMap(null);
	    }
	}
	markersArray = [];
}