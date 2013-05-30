jQuery ($) ->

	c = $('#homepage-counter').data('counter')
	brand = $('body').data('brand')
	if c && brand == "dbx"
		n = Math.floor(1 / (Math.pow((getWeekNumber() / 24), 6) / 100))
		# Uncomment below to enable the two hack
		# theTwo() if (c % n) == 0

getWeekNumber = ->
	d = new Date()
	d.setHours(0,0,0)
	d.setDate(d.getDate() + 4 - (d.getDay()||7))
	yearStart = new Date(d.getFullYear(),0,1)
	Math.ceil(( ( (d - yearStart) / 86400000) + 1)/7)

theTwo = ->
	$("div.slideshow_frame").each ->
		$(@).html("<h1 style=\"font-size: 120px\">THE TWO...REVOLUTION, NOT EVOLUTION!!</h1>")
	# alert("The 2!")