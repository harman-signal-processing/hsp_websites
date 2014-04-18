jQuery ($) ->
	if $("#featured_product_container").visible(true)
		$("#featured_image").css("margin-left", "-10%")
	else
		$("#featured_image").css("margin-left", "-25%")

win = $(window)

win.scroll -> 
	scroll = win.scrollTop()
	if scroll <= 0
		$('.bouncing-arrow').not(':animated').fadeIn(500)
	else
		$('.bouncing-arrow').not(':animated').fadeOut(500)

		pos = -25 + ((scroll - 25) * .1) 
		pos = 0 if pos > 0
		pos = -25 if pos < -25
		#console.log("Position: #{pos}%")
		$("#featured_image").css("margin-left", "#{pos}%")

