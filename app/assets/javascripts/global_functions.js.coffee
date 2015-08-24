jQuery ($) ->

	$('a#locale_menu').click (e) ->
		e.preventDefault()
		$('#locale_selections').toggle()

	$('.ui-datepicker').datepicker
		inline: true
		numberOfMonths: 2
		showButtonPanel: true	
		dateFormat: "DD, MM d, yy"
		constrainInput: true

	$('.ui-datepicker-past-only').datepicker
		inline: true
		numberOfMonths: 1
		showButtonPanel: true	
		dateFormat: "DD, MM d, yy"
		constrainInput: true
		maxDate: 0

	$('.ui-datetimepicker').datetimepicker
		ampm: true

	$("div#purchased_on_picker").datepicker
		altField: "#warranty_registration_purchased_on"
		altFormat: "yy-mm-dd"
		defaultDate: $("div#purchased_on_picker").data('default')
		numberOfMonths: 1
		maxDate: 0

	# hide the text field with the date (don't use a hidden field so we can test the form)
	# $("form#new_warranty_registration #warranty_registration_puchased_on").hide()
