jQuery ($) ->

	$('a#locale_menu').click (e) ->
		e.preventDefault
		$('#locale_selections').toggle()

	load_lightbox = () ->
		$('a.lightbox').lightBox
			imageBtnClose: '/images/lightbox-btn-close.gif'
			imageLoading: '/images/lightbox-ico-loading.gif'
			imageBtnPrev: '/images/lightbox-btn-prev.gif'
			imageBtnNext: '/images/lightbox-btn-next.gif'
			imageBlank: '/images/lightbox-blank.gif'

	load_lightbox()

	datepicker = $('.ui-datepicker').datepicker
		inline: true
		numberOfMonths: 2
		showButtonPanel: true	
		dateFormat: "DD, MM d, yy"
	datepicker.show()

	$('.ui-datetimepicker').datetimepicker
		ampm: true
