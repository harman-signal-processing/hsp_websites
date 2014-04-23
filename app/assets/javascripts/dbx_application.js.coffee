jQuery ($) ->
	win = $(window)
	if $("#featured_product_container") && win.scrollTop() < 100
		$("#featured_image").css("margin-left", "-25%")

win = $(window)

win.scroll -> 
	scroll = win.scrollTop()
	if scroll <= 0
		$('.bouncing-arrow').not(':animated').fadeIn(500)
		#$("#video_background").css('bottom', '0px')
		$("#middle_features").css('margin-bottom', "-60px")
		$("#featured_image").css("margin-left", "-25%")
	else
		$('.bouncing-arrow').not(':animated').fadeOut(500)

		pos = -25 + ((scroll - 25) * .05) 
		pos = 0 if pos > 0
		pos = -25 if pos < -25
		#console.log("Position: #{pos}%")
		$("#featured_image").css("margin-left", "#{pos}%")
		$("#middle_features").css('margin-bottom', "#{(scroll * .15) - 60}px")

		if scroll > 200
			$("#video_background").css('bottom', "150px")
		# else
		# 	$("#video_background").css('bottom', "#{scroll * 0.3}px")
