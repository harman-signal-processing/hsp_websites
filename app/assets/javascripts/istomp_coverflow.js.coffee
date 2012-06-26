jQuery ($) ->

	total_items = parseInt($("#epedals").data('count'))

	coverflowApp = 
		defaultItem: $('.defaultItem').data('position') || (total_items / 2) - 1
		defaultDuration: 1100
		html: $('div#coverflow_container div.wrapper').html()
		sliderCtrl: $('div#coverflow_container #slider')
		coverflowCtrl: $('div#coverflow_container #coverflow')
		coverflowImages: $('div#coverflow_container #coverflow').find('img')
		feature_pop: $('div#feature_pop')
			
		init_coverflow: (elem) ->
			@feature_pop.hide()
			@coverflowCtrl.coverflow
				item: coverflowApp.defaultItem
				duration: 1200
				select: (event, sky) => @skipTo(sky.value)	
			@skipTo(@defaultItem, true)
			@init_slider(@sliderCtrl)
			@init_keyboard()
			$('a#popclose').click (e) =>
				e.preventDefault()
				@feature_pop.stop().fadeOut()
			$('div#coverflow_container div#mask').delay(500).fadeOut(700, 'swing')
		
		init_slider: (elem) ->
			elem.slider
				min: 0
				max: $('#coverflow > *').length - 1
				value: coverflowApp.defaultItem
				start: => @feature_pop.stop().fadeOut()
				slide: (event, ui) => @skipTo(ui.value, true)
				stop: (event, ui) => @thrill_rob(ui.value)

		thrill_rob: (itemNumber, delayValue=1200, skipPop=false) ->
			@coverflowImages.each (index) ->
				if index == itemNumber && !skipPop
					if $('#coverflow_settings').data('jump') == true
						$('div#coverflow_container div#label').append("<span style='color: #888; text-decoration: blink'> ...</span>")
						window.location = $(@).data('itemlink')
					else if $('#coverflow_settings').data('changelabel') == true
						newsrc = $(@).data('labelimg') || $("img#label_changer").data('orig')
						$("img#label_changer").attr('src', newsrc)
					else
						pophtml_selector = $(@).data('pophtml')
						$('div#feature_pop').queue (next) ->
							$('div#pop_content').html($("##{pophtml_selector}").html())
							$('div#feature_pop').delay(delayValue).fadeIn()
							next()

		skipTo: (itemNumber, skipPop=false) ->
			@feature_pop.stop().fadeOut()
			@sliderCtrl.slider("option", "value", itemNumber)
			@coverflowCtrl.coverflow('select', itemNumber, true)
			@coverflowImages.each (index) ->
				if index == itemNumber
					$(@).css('cursor', 'pointer')
					$(@).click -> 
						$('div#feature_pop').remove()
						window.location = $(@).data('itemlink')
					$('div#coverflow_container div#label').html("<a href=\"#{$(@).data('itemlink')}\">#{$(@).data('caption')}</a>")
					coverflowApp.thrill_rob(itemNumber) unless skipPop
				else
					$(@).css('cursor', 'default')
					$(@).unbind().click -> coverflowApp.skipTo(index)

		init_keyboard: ->
			$(document).keydown (e) ->
				current = coverflowApp.sliderCtrl.slider('value')
				if e.keyCode == 37 and current > 0
					current--
					coverflowApp.skipTo(current)
				else if e.keyCode == 39 && current < ($('#coverflow > *').length - 1)
					current++
					coverflowApp.skipTo(current)

	coverflowApp.init_coverflow()
	
