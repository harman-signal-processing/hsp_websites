jQuery ($) ->
	# slides in the featured product on scroll down...not sure I like it...
	# win = $(window)
	# if $("#featured_product_container") && win.scrollTop() < 100
	#	$("#featured_image").css("margin-left", "-35%")
	$("#tagline").hide().delay(1000).fadeIn(1500)

win = $(window)

win.scroll -> 
	scroll = win.scrollTop()
	if scroll <= 0
		$('.bouncing-arrow').not(':animated').fadeIn(500)
		$("#video_background").css(bottom: '0px')
		$("#tagline").css(bottom: '-20px');
		#$("#middle_features").css('margin-bottom', "-20px")
		#$("#featured_image").css("margin-left", "-35%")
		$("#tagline").fadeIn(900)
	else
		$('.bouncing-arrow').not(':animated').fadeOut(500)

		#pos = -35 + ((scroll - 25) * .05) 
		#pos = 0 if pos > 0
		#pos = -35 if pos < -35

		#$("#featured_image").css("margin-left", "#{pos}%")
		#$("#middle_features").css('margin-bottom', "#{(scroll * .15) - 20}px")

		$("#tagline").fadeOut(2500)
		#$('#tagline').css(bottom: "#{(scroll * .25) - 20}px")

		if scroll > 500
			$("#video_background").css(bottom: "150px")
		else
		 	$("#video_background").css('bottom', "#{scroll * 0.3}px")
