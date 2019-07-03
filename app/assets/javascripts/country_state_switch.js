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
        filter_by_state(selected_state);
  });		//  $('#state-switch').change(function(e){
	
	function filter_by_state(selected_state)
	{
	  var  has_service_centers = false,
        $default_service_center_message = $("#default_service_center_message");
        
    $default_service_center_message.hide('slow');
    
    $("#service_center_list li").each(function(i)
    {
    	var $li = $(this),
    			service_center_state = $li.attr('id').split('_')[1];
    			
    			$li.hide('slow');
    			
    			if(selected_state == service_center_state)
    			{
    				$li.show('slow');
    				has_service_centers = true;
    			}
    });  //  $("#service_center_list li").each(function(i)
    
    if (!has_service_centers)
    {$default_service_center_message.show('slow');}	  
	  
	}  // function filter_by_state(state)
	
	//If the page loaded with a state selected go ahead and filter by the selected state
	if ($("#state-switch").length > 0 && $("#state-switch").val().length > 0)
	{
	  filter_by_state($('#state-switch').val());
	}	
	
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