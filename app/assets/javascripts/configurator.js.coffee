jQuery ($) ->

  $('#system_summary_container ').pin
    containerSelector: $('#main_container')
    padding: {top: 100}

  $("div.long_description").hide()

  $("a.help").click (e) ->
    e.preventDefault()
    container = $(this).data('container')
    $("##{container}").toggle()

  tallest = 0
  $("div.starter_option").each ->
    h = $(@).height()
    tallest = h if h > tallest

  $("div.starter_option").each -> $(@).css('height': "#{tallest+20}px")

