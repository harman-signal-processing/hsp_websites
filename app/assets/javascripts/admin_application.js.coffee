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

	$('form').on 'click', '.remove_fields', (event) ->
		$(@).closest('div.row').find('input[type=hidden]').val('1')
		$(@).closest('div.row').hide()
		event.preventDefault()

	$('form').on 'click', '.add_fields', (event) ->
		time = new Date().getTime()
		regexp = new RegExp($(@).data('id'), 'g')
		$(@).closest('div.row').before($(@).data('fields').replace(regexp, time))
		event.preventDefault()

