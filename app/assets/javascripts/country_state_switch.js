$(function()
{
  /*used in /support area of brand sites */
  $('#country-switch').change(function(e){
    var $this = $(this),
        country_code = $this.val();
    if (country_code.length > 0)
    {
      location.search = 'geo=' + country_code.toLowerCase();
    }
  });	
	
  $('#state-switch').change(function(e){
    var $this = $(this),
        selected_state = $this.val();
    location.search = 'geo=' + location.search.split('geo=')[1].split('&')[0] + '&state=' + selected_state.toLowerCase();
  });		//  $('#state-switch').change(function(e){

	
	function ensureGeoUrlParamIsPresentWhenCountrySelectorPresent()
	{
	  var geoParamIsMissing = location.search.indexOf("geo=") == -1,
	      $countryswitcher = $('#country-switch'),
	      countryselected = typeof $countryswitcher.val() == "undefined" ? "" : $countryswitcher.val(),
	      countryIsSelected = countryselected.length > 0;
	  
	  if (geoParamIsMissing && countryIsSelected)
	  {
	    location.search = 'geo=' + $('#country-switch').val().toLowerCase();
	  }
	}  //  function ensureGeoUrlParamIsPresentWhenCountrySelectorPresent()
	
	ensureGeoUrlParamIsPresentWhenCountrySelectorPresent();
	
});  //  $(function()