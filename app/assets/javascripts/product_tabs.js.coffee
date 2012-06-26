jQuery ($) ->

	$('ul#product_main_tabs li a').click (e) ->
		e.preventDefault
		this_tab = $(@).data('tabname')
		$('div.product_main_tab_content').each -> $(@).hide()
		$("div##{this_tab}_content").show()
		$('ul#product_main_tabs li').each -> $(@).removeClass('current')
		$("li##{this_tab}_tab").addClass('current')
		return false
