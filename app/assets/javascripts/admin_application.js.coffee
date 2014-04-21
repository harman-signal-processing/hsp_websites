jQuery ($) ->
	$('.limited').each ->
		charlimit = $(@).data('charlimit')

		opts =
			maxCharacterSize: charlimit
			originalStyle: 'hint'
			warningStyle: 'warning'
			warningNumber: 5
			displayFormat: "#input characters (#left remaining)"

		$(@).textareaCount(opts)