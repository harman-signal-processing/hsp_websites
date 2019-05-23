$(function()
{
  /*used in /support area of brand sites */
  $('#country-switch').change(function(e){
    var $this = $(this),
        country_code = $this.val();
    location.search = 'geo=' + country_code.toLowerCase();
  });	
	
  $('#state-switch').change(function(e){
    var $this = $(this),
        selected_state = $this.val(),
        has_service_centers = false,
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
    
  });		//  $('#state-switch').change(function(e){
	
});  //  $(function()