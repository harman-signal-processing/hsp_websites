jQuery ($) ->
	#skrollr.init()
	win = $(window)

	animation_started = false

	$("#tagline").hide().delay(1000).fadeIn(1500)

	social_icons = $("div.social a")
	video_clips  = $(".video_thumbnail")	
	if win.scrollTop() <= 0
		social_icons.fadeTo(0,0)
		video_clips.fadeTo(0,0)

	win.scroll -> 
		scroll = win.scrollTop()
		win_height = scroll + win.height()
		# console.log ("scroll: #{scroll}, win.height: #{win.height()}")
		social_icons.each (i) -> 
			a = $(@).offset().top + $(@).height() + ((i-1) * 50)
			if (a < win_height) 
				$(@).fadeTo(500,1)

		video_clips.each (i) -> 
			a = $(@).offset().top + $(@).height() + ((i-1) * 40)
			if (a < win_height) 
				$(@).fadeTo(500,1) 

		if scroll <= 0
			$('.bouncing-arrow').not(':animated').fadeIn(500)
			$("#video_background").css(bottom: '0px')
			$("#tagline").css(bottom: '-20px');
			$("#tagline").fadeIn(900)
		else
			$('.bouncing-arrow').not(':animated').fadeOut(500)
			$("#tagline").fadeOut(2500)
			if scroll > 1000
				$("#video_background").css(bottom: "150px")
			else
			 	$("#video_background").css('bottom', "#{scroll * 0.3}px")
