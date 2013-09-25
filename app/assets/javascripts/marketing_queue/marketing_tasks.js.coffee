# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ($) ->

	$("select#marketing_task_brand_id").change ->
		brand = $(@).val()
		$.get "/marketing_queue/brands/#{brand}/marketing_projects.js"
