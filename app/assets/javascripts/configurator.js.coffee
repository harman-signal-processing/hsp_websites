jQuery ($) ->

	$('#system_summary_container ').stickyScroll
		container: $('#content_container_content')

	$("div.long_description").hide()

	$("a.help").click (e) ->
		e.preventDefault()
		container = $(this).data('container')
		$("##{container}").toggle()
