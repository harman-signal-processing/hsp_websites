jQuery ($) ->
	ua = navigator.userAgent.toLowerCase()
	supported_devices_url = $('span#help_links').data('supported')
	non_ios_url = $('span#help_links').data('howto')
	
	if supported_devices_url
		#// non-iOS notices
		unless (ua.indexOf('iphone') != -1) || (ua.indexOf('ipod') != -1) || (ua.indexOf('ipad') != -1)
			$('a.stomp_shop_app').click (e) ->
				if ua.indexOf("android") > -1
					e.preventDefault()
					window.location = supported_devices_url
				else if non_ios_url
					e.preventDefault()
					window.location = non_ios_url

	# Collection of all audio demo files (even below the coverflow)					
	# audio_demos = []
	# $('a.audio_demo').each -> 
	# 	if $(@).data('wet') and $(@).data('dry')
	# 		audio_demos.push {id: $(@).attr('id'), product_id: $(@).data('product'), wet: $(@).data('wet'), dry: $(@).data('dry')}

	class Toggler

		constructor: (@sm, @selector='a#current_pedal_sample') ->
			@element = $(@selector)
			@msg = $('div#demo_msg')
			@wet = @element.data('wet')
			@dry = @element.data('dry')
			@pedal_image = $("img##{@element.data('pedal')}")
			@pedal_image_off = @pedal_image.attr('src')
			@pedal_image_on = @pedal_image.data('effecton')
			@setup_sounds()
			@handle_click()

		handle_click: ->
			@element.click (e) =>
				e.preventDefault()
				if @sample_on.playState is 1 then @pause_demo() else @start_demo()
			@pedal_image.click (e) =>
				e.preventDefault()
				if @sample_on.playState is 1 then @toggle_effect() else @start_demo()

		pause_demo: =>
			@sample_on.stop()

		start_demo: =>
			@sample_on.play()

		create_message: =>
			@msg.text('tap the pedal to toggle the effect').css('color', 'red')

		remove_message: =>
			@msg.text('')

		toggle_effect: =>
			if @sample_on.muted then @turn_effect_on() else @turn_effect_off()

		turn_effect_off: =>
			@pedal_image.attr('src', @pedal_image_off)
			@sample_on.mute()
			@sample_off.unmute()
			@msg.css('color', 'black')

		turn_effect_on: =>
			@pedal_image.attr('src', @pedal_image_on)
			@sample_on.unmute()
			@sample_off.mute()
			@msg.css('color', 'red')	

		setup_sounds: =>
			@sample_off = @sm.createSound(
				id: 'effect_off'
				url: @dry
			)
			@sample_on = @sm.createSound(
				id: 'effect_on'
				url: @wet
				onplay: => 
					@sample_off.play().mute()
					@element.addClass('sm2_playing')
					@pedal_image.attr('src', @pedal_image_on)
					@create_message()
				onfinish: => 
					@element.removeClass('sm2_playing')
					@pedal_image.attr('src', @pedal_image_off)
					@remove_message()
				onstop: => 
					@sample_off.stop()
					@pedal_image.attr('src', @pedal_image_off)
					@element.removeClass('sm2_playing')
					@remove_message()
				onpause: =>
					@sample_off.pause()
			)

	soundManager.onready () -> 
		current_sample = new Toggler(soundManager)
		inlinePlayer = new InlinePlayer()
	
	class BigGroupButton

		constructor: (@container='#epedals', @button_selector='img.view_all_button') ->
			@buttons = $(@button_selector)
			@main_button = $("#{@button_selector}(eq:first)")
			@hidden = $(@container).hide()
			@setup_view_button()
			@handle_click()
			
		hide_me: ->
			@setup_view_button()
			@hidden = $(@container).slideUp()

		show_me: ->
			@setup_hide_button()
			@hidden = !($(@container).slideDown(1200))

		handle_click: ->
			@buttons.click (e) =>
				e.preventDefault()
				if @hidden then @show_me() else @hide_me()

		setup_view_button: ->
			@main_button.hover(
				=> @main_button.attr('src', @main_button.data('originalover'))
				=> @main_button.attr('src', @main_button.data('originalsrc'))
			)

		setup_hide_button: ->
			@main_button.hover(
				=> @main_button.attr('src', @main_button.data('hideover'))
				=> @main_button.attr('src', @main_button.data('hidesrc'))
			)			

	new BigGroupButton()


	#// Update e-pedal count
	total_epedals = $("#epedals").data('count')
	$('.description p').each ->
		$(@).text($(@).text().replace(/the\s\d{1,}/, "the #{total_epedals}"))

	$('.features ul li').each ->
		$(@).text($(@).text().replace(/offers more than \d{1,} different/, "offers #{total_epedals} different"))

