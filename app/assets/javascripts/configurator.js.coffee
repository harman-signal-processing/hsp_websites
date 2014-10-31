jQuery ($) ->

  $('#system_summary_container ').pin
    containerSelector: $('#content_container_content')

  $("div.long_description").hide()

  $("a.help").click (e) ->
    e.preventDefault()
    container = $(this).data('container')
    $("##{container}").toggle()

  tallest = 0
  $("div.starter_option").each ->
    h = $(@).height()
    tallest = h if h > tallest

  $("div.starter_option").each -> $(@).css('min-height': "#{tallest}px")

