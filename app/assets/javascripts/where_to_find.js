var markerHash = {};
var markersArray = [];
var map;
var currentFocus = false;
var browserSupportFlag = new Boolean();
var initialLocation;
var currentInfoWindow = false;

function map_init(lat, lng, zoom) {
  var mapcenter = new google.maps.LatLng(lat, lng);
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: zoom,
    center: mapcenter,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });
  load_markers(map, markers_json);

  map.addListener('idle', function() {
    var newcenter = map.getCenter();
    var distance_moved = google.maps.geometry.spherical.computeDistanceBetween(mapcenter, newcenter);
    if (distance_moved > 5000) {
      refresh_map(map);
      mapcenter = newcenter;
    }
  });

  window.map = map;
}

function load_markers(map,markers) {
  for (var i = 0 ; i < markers.length ; i++) {
    var marker = markers[i];
    var lat = marker.lat;
    var lng = marker.lng;
    if (lat && lng) {
      var innerHtml = '<div class="marker_info"><b style="font-size: 13px">'
        + marker.name + '</b><br/>'
        + marker.address + '<br/>'
        + marker.city + ', ' + (marker.state ?? '') + ' ' + marker.zip + '<br/>'
        + marker.telephone
        + '</div>';
      var mymarker = addMarker(map,parseFloat(lat),parseFloat(lng),innerHtml,(i + 1));
      markersArray.push(mymarker);
      markerHash[(i + 1)] = {marker:mymarker,address:innerHtml};
    }
  }
}

function refresh_map(map) {
  var mapcenter = map.getCenter();
  var lat = mapcenter.lat();
  var lng = mapcenter.lng();
  clearOverlays();
  $("ul.dealer_results li").remove();

  // var url = "/where_to_find/partner_search.json?lat=" + lat + "&lng=" + lng
  var url = location.pathname + ".json?lat=" + lat + "&lng=" + lng;
  if ( $("input[name='apply_filters']").val() == 1 ) {
    url += "&apply_filters=1"
    $.each($("div#wtb_container input[type='checkbox']:checked"), function() {
      url += "&"+$(this).attr('name')+"=1"
    });
  }
  // add rental if url contains 'vertec_vtx_owners_search'
  if (url.includes("vertec_vtx_owners_search")) {
    url += "&rental_vtx=1"
  }

  $.getJSON(url, function ( data ) {
    load_markers(map, data);
    load_side_column(data);
    load_results_count(data.length);
  });
}

function load_results_count(count) {
  $("#dealer_results_count").html(count);
}

function load_side_column(markers) {
  for (var i = 0 ; i < markers.length ; i++) {
    var marker = markers[i];
    var innerHtml = "<b><a href=\"#\" data-item-id=\"" + (i + 1) +"\" class=\"mapper\">" + marker.name + "</a></b> ";

    if ( $("div#wtb_container").data("include-rental-and-service") ) {
      if ( marker.resale == 1) {
        innerHtml += '<i title="Reseller" class="fa fa-shopping-cart"></i>'
      }
      if ( marker.rental == 1 ) {
        innerHtml += '<i title="Rentals" class="fa fa-road"></i>'
      }
      if ( marker.service == 1 ) {
        innerHtml += '<i title="Service" class="fa fa-wrench"></i>'
      }
    }
    if ( marker.distance ) {
      innerHtml += " (" + parseInt(marker.distance) + " miles) ";
    }
    if ( marker.rental == 1 && marker.products ) {
      innerHtml += "<br/><i>Products available: " + marker.products + "</i>"
    }
    innerHtml += "<br/>" + marker.address
          + "<br/>" + marker.city + ', ' + (marker.state ?? '') + ' ' + marker.zip;
    if ( marker.country ) {
      innerHtml += "<br/>" + marker.country;
    }
    if ( marker.telephone ) {
      innerHtml += "<br/>" + marker.telephone;
    }
    if ( marker.website) {
      innerHtml += "<br/><a href=\"" + marker.website_link + "\" target=\"_blank\">" + marker.website + "</a>";
    } else if ( marker.email ) {
      innerHtml += "<br/><a href=\"mailto:" + marker.email +"\">" + marker.email + "</a>";
    }

    $("<li/>").attr('id', "sidebar-item-" + (i + 1)).addClass("sidebar-item").html(innerHtml).appendTo("ul.dealer_results");
  }
}

function addMarker(map, lat, lng, description, id) {
  var myLatLng = new google.maps.LatLng(lat, lng);
  var marker = new google.maps.Marker({
    position: myLatLng,
    map: map,
    animation: google.maps.Animation.DROP
  });
  if (description != '') {
    var info_window = new google.maps.InfoWindow({
      content: description,
      disableAutoPan: true
    });
    google.maps.event.addListener(marker, 'click', function() {
      if ( currentInfoWindow ) {
        currentInfoWindow.close();
      }
      info_window.open(map,marker);
      currentInfoWindow = info_window;
      focusSideBar(id);
    });
  }
  return marker;
}

function focusPoint(id){
  focusSideBar(id);
  var info_window = new google.maps.InfoWindow({
    content: markerHash[id].address,
    disableAutoPan: true
  });
  if ( currentInfoWindow ) {
    currentInfoWindow.close();
  }
  info_window.open(map,markerHash[id].marker);
  currentInfoWindow = info_window;
}

function focusSideBar(id){
  if (currentFocus) {
    $("#sidebar-item-"+currentFocus).removeClass("current");
  }
  $("#sidebar-item-"+id).addClass("current");
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

jQuery(function($) {
  $("ul.dealer_results").on('click', "a.mapper", function() {
    focusPoint( $(this).data("item-id") );
    return false;
  });
});
