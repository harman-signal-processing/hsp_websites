# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ($) ->

	if $('#tasks-overview')[0] # only attempt to generate graph if container is present
		Morris.Area
			element: 'tasks-overview'
			xkey: 'y'
			ykeys: ['a', 'b']
			labels: ['Series A', 'Series B']
			data: [
				{ y: '2006', a: 100, b: 90 }
				{ y: '2007', a: 75,  b: 65 }
				{ y: '2008', a: 50,  b: 40 }
				{ y: '2009', a: 75,  b: 65 }
				{ y: '2010', a: 50,  b: 40 }
				{ y: '2011', a: 75,  b: 65 }
				{ y: '2012', a: 100, b: 90 }
			]

