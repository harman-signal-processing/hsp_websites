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
		$("sidebar-item-"+currentFocus).removeClass("current");
	}
	$("sidebar-item-"+id).addClass("current");
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