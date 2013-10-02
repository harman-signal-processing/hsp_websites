# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ($) ->

	datepicker = $('.ui-datepicker').datepicker
		inline: true
		numberOfMonths: 2
		showButtonPanel: true	
		dateFormat: "DD, MM d, yy"
	datepicker.show()

	$('.ui-datetimepicker').datetimepicker
		ampm: true

	if $('#overview')[0] # only attempt to generate graph if container is present
		Morris.Donut
			element: 'overview'
			data: $('#overview').data('brands')

	$('a#toggle-formatting').click (e) ->
		e.preventDefault()
		$('div#formatting-tips').toggle()

	$('input.completer').prop("checked", false).each -> new Completer(@) 
	$('input.incompleter').prop("checked", true).each -> new Completer(@)

class Completer

	constructor: (checkbox) ->
		@checkbox = $(checkbox)
		@task_id = @checkbox.data('task') 
		@project_id = @checkbox.data('project')
		@worker = @checkbox.data('worker')
		@due_on = @checkbox.data('due_on')
		@checkbox.click () =>
			if @project_id > 0 then @update_counters()
			if @checkbox.hasClass('completer') then @complete() else @uncomplete(@worker, @due_on)
			@update_database()
			if @project_id > 0 then @update_progress()
		
	update_progress: ->
		$('h5#completed-tasks-title').html("Completed Tasks (#{@project_completed_count})")
		percent_complete = Math.floor ((@project_completed_count / (@project_incomplete_count + @project_completed_count) ) * 100)
		$("span#meter-#{ @project_id }").css('width', "#{ percent_complete }%")
		$("#percent-complete-#{ @project_id }").html(" #{ percent_complete }% complete")

	update_database: ->
		$.ajax "/marketing_queue/marketing_tasks/#{@task_id}/toggle"

	update_counters: () ->
		@project_task_counter = $("#task-counter-#{ @project_id }")
		@project_completed_count = @project_task_counter.data('completedcount')
		@project_incomplete_count = @project_task_counter.data('incompletecount')
		if @checkbox.hasClass('completer')
			@project_completed_count += 1
			@project_incomplete_count -= 1
		else
			@project_completed_count -= 1
			@project_incomplete_count += 1
		@project_task_counter.data('completedcount', @project_completed_count)
		@project_task_counter.data('incompletecount', @project_incomplete_count)
		@update_progress

	complete: ->
		@checkbox.removeClass('completer').addClass('incompleter')
		$("#task_row_#{@task_id}").fadeOut 'fast', ->
			$(@).find('input').prop("checked", true)
			if $(@).is('li')
				$(@).find('i').hide()
				$(@).find('.assigned').html('Completed: just now')
				$(@).prependTo('ul#completed-tasks').fadeIn('fast')
			else
				$(@).find('td.date').html('just now')
				$(@).prependTo('table#completed-tasks tbody').show()
	
	uncomplete: (w, d) ->
		@checkbox.removeClass('incompleter').addClass('completer')
		$("#task_row_#{@task_id}").fadeOut 'fast', ->
			$(@).find('input').prop("checked", false)
			if $(@).is('li')
				$(@).find('i').show()
				label = if w == 'Unassigned' then "<span class='alert round label'>#{w}</span>" else "Assigned to: #{w}"
				$(@).find('.assigned').html(label)
				$(@).prependTo('ul#incomplete-tasks').fadeIn('fast')			
			else
				$(@).find('td.date').html(d)
				$(@).prependTo('table#incomplete-tasks tbody').show()		
		



