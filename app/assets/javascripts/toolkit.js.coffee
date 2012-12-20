jQuery ($) ->
	$(document).foundationTopBar()
	$(document).foundationNavigation()

	$('.description').click -> $(@).selText()
