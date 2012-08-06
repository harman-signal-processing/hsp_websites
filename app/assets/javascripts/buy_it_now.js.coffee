jQuery ($) ->
	blanket_size = (popUpDivVar) ->
		$('#blanket').css('height', "#{$(window).width()}px")
		popUpDiv_height = 120 
		$("##{popUpDivVar}").css('top', "#{popUpDiv_height}px")
		$("##{popUpDivVar}_close").css('top', "#{popUpDiv_height - 16}px")

	window_pos = (popUpDivVar) ->
		window_width = $(window).innerWidth()
		$("##{popUpDivVar}").css('left', (window_width/2-370) + 'px')
		$("##{popUpDivVar}_close").css('right', (window_width/2-418) + 'px')
	
	window.popup = (windowname) ->
		blanket_size(windowname)
		window_pos(windowname)
		$('#blanket').toggle()
		$("##{windowname}").toggle()
		$("##{windowname}_close").toggle()

	$('a.buy_it_now_popup').click (e) ->
		e.preventDefault()
		windowname = $(@).data('windowname')
		window.popup(windowname)
	