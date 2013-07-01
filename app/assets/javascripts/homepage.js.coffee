jQuery ($) ->

	c = $('#homepage-counter').data('counter')
	brand = $('body').data('brand')
	if c && brand == "dbx"
		n = Math.floor(1 / (Math.pow((w / 24), 6) / 100))
		# Uncomment below to enable the two hack
		theTwo() if c % n == 0

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
