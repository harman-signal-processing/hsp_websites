# Includes a fancy countdown timer for the dbx homepage. To use, make
# sure these 'Settings' exist in the dbx web admin: (sample values shown)
#
#  countdown_container: countdown
#  countdown_overlay_position: 0  # (0 = first slide)
#  countdown_next_event: 2013-10-15,2013-11-15,2014-04-30,2014-05-30,2014-06-30,2014-08-30
#
jQuery ($) ->

	brand = $('body').data('brand')
	next_event = $('#homepage-counter').data('nextevent')
	container_id = $('#homepage-counter').data('countdowncontainer')
	if next_event && container_id
		new CountDownTimer(next_event, container_id)

# 	c = $('#homepage-counter').data('counter')
# 	brand = $('body').data('brand')
# 	if c && brand == "dbx"
# 		n = Math.floor(1 / (Math.pow((w / 30), 9) / 100))
# 		# Uncomment below to enable the two hack
# 		n = 1 if n < 1
# 		theTwo() if c % n == 0

class CountDownTimer

	constructor: (future_date, selector) ->
		@element = $("##{selector}")
		@future_date = new Date(future_date)
		@future_date.setTime( @future_date.getTime() + @future_date.getTimezoneOffset()*60*1000 )
		@_second = 1000
		@_minute = @_second * 60
		@_hour = @_minute * 60
		@_day = @_hour * 24
		@timer = setInterval =>
			@showRemaining()
		, 1000

	showRemaining: ->
		distance = @future_date - new Date()
		if (distance < 0)
			clearInterval(@timer)
			@element.html('')
		else
			days = Math.floor(distance / @_day)
			hours = Math.floor((distance % @_day) / @_hour)
			minutes = Math.floor((distance % @_hour) / @_minute)
			seconds = Math.floor((distance % @_minute) / @_second)
			@element.html("Hurry, only <strong>#{days} days, #{('00'+hours).substr(-2)}:#{('00'+minutes).substr(-2)}:#{('00'+seconds).substr(-2)}</strong> remaining!")

getWeekNumber = ->
	d = new Date()
	d.setHours(0,0,0)
	d.setDate(d.getDate() + 4 - (d.getDay()||7))
	yearStart = new Date(d.getFullYear(),0,1)
	Math.ceil(( ( (d - yearStart) / 86400000) + 1)/7)

theTwo = ->
	h = document.createElement('div')
	$(h).css("position", "absolute").css("z-index", "1000").css("width", "100%").css("text-align", "center")
	.html('<img src="/assets/dbx/DBX_WEBSITE_HACK.png" style="max-width: 1100px;"/>')
	.prependTo($('body'))
	.delay(12000).fadeOut(300)
	.click () -> $(@).remove()

	# $("div.slideshow_frame").each ->
		# $(@).html("<h1 style=\"font-size: 120px\">THE TWO...REVOLUTION, NOT EVOLUTION!!</h1>")

