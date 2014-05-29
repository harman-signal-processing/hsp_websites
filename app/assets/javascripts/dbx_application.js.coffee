jQuery ($) ->
	skrollr.init()
	$("#tagline").hide().delay(1000).fadeIn(1500)

win = $(window)

win.scroll -> 
	scroll = win.scrollTop()
	if scroll <= 0
		$('.bouncing-arrow').not(':animated').fadeIn(500)
		$("#video_background").css(bottom: '0px')
		$("#tagline").css(bottom: '-20px');
		$("#tagline").fadeIn(900)
	else
		$('.bouncing-arrow').not(':animated').fadeOut(500)
		$("#tagline").fadeOut(2500)
		if scroll > 500
			$("#video_background").css(bottom: "150px")
		else
		 	$("#video_background").css('bottom', "#{scroll * 0.3}px")
