jQuery ($) ->
	#skrollr.init()
	win = $(window)

	hidden_icon_containers = $(".hidden_icons")

	$(".hidden_icons img").each ->
		$(@).parent().css(position: 'relative')
		$(@).css(position: 'absolute', 'z-index': '0', top: "-95px", left: "-1000px")

	icon_animator = -> 
		$(".hidden_icons img").each (i, element) ->
			$(@).css(position: 'absolute', 'z-index': '0', top: "-95px", left: "-1000px")
			$(@).delay(i * 1500).animate({left: "150px"}, 3000).delay(500).animate(top: "20px")

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

		social_icons.each (i) -> 
			a = $(@).offset().top + $(@).height() + ((i-1) * 50)
			if (a < win_height) 
				$(@).fadeTo(500,1)

		video_clips.each (i) -> 
			a = $(@).offset().top + $(@).height() + ((i-1) * 40)
			if (a < win_height) 
				$(@).fadeTo(500,1) 

		hidden_icon_containers.each (i) ->
			a = $(@).offset().top + $(@).height() + ((i-1) * 10)
			if a < win_height && animation_started == false
				icon_animator()
				setInterval icon_animator, 23000
				animation_started = true

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
