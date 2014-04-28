jQuery ($) ->
	# slides in the featured product on scroll down...not sure I like it...
	# win = $(window)
	# if $("#featured_product_container") && win.scrollTop() < 100
	#	$("#featured_image").css("margin-left", "-35%")

win = $(window)

win.scroll -> 
	scroll = win.scrollTop()
	if scroll <= 0
		$('.bouncing-arrow').not(':animated').fadeIn(500)
		#$("#video_background").css('bottom', '0px')
		$("#middle_features").css('margin-bottom', "-60px")
		#$("#featured_image").css("margin-left", "-35%")
	else
		$('.bouncing-arrow').not(':animated').fadeOut(500)

		#pos = -35 + ((scroll - 25) * .05) 
		#pos = 0 if pos > 0
		#pos = -35 if pos < -35

		#$("#featured_image").css("margin-left", "#{pos}%")
		$("#middle_features").css('margin-bottom', "#{(scroll * .15) - 60}px")

		if scroll > 200
			$("#video_background").css('bottom', "150px")
		# else
		# 	$("#video_background").css('bottom', "#{scroll * 0.3}px")
