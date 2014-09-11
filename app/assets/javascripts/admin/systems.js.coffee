# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->

	show_system_options = () -> 
		option_type = $("#system_option_option_type option").filter(':selected').val()
		container   = $("#option_values_container")

		types_with_values = ['dropdown', 'radio', 'checkbox']
		if option_type in types_with_values then container.show() else container.hide()
		container.find('label:first').html("Possible #{option_type} values for this option:")

	show_system_options() 

	$('#system_option_option_type').change -> show_system_options()

