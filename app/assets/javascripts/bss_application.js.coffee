jQuery ($) ->

  changeWord = (elem, word) ->
    elem.delay(900).fadeOut(500, ->
      elem.text(word)
    ).fadeIn(500)

  # Cycling through words of a headline.
  $('.wordchanger').each ->
    words = $(@).data("words").split(',')
    words.push $(@).text()
    for n in [1..20]
      changeWord($(@), word) for word in words

  # An attempt to do the sticky box on the right side of the new
  # bss product page.
  $('.product-title-block').pin
    containerSelector: $('#product-content-container')
    padding: {top: 100}

  $('.sticky-side').pin
    containerSelector: $('.sticky-container')
    padding: {top: 100}

  win = $(window)
  animation_started = false

  $("#tagline").hide().delay(1000).fadeIn(1500)

  social_icons = $("div.social a")
  video_clips  = $(".video_thumbnail")
  if win.scrollTop() <= 0
    social_icons.fadeTo(0,0)
    video_clips.fadeTo(0,0)

  win.scroll ->
    scroll = win.scrollTop()
    win_height = scroll + win.height()
    # console.log ("scroll: #{scroll}, win.height: #{win.height()}")
    social_icons.each (i) ->
      a = $(@).offset().top + $(@).height() + ((i-1) * 50)
      if (a < win_height)
        $(@).fadeTo(500,1)

    video_clips.each (i) ->
      a = $(@).offset().top + $(@).height() + ((i-1) * 40)
      if (a < win_height)
        $(@).fadeTo(500,1)

    $(".hidden_icons").each (i) ->
      a = $(@).offset().top + $(@).height() + 200
      if a < win_height && animation_started == false
        animation_started = true
        icon_animator()
        # setInterval icon_animator, 8000

    if scroll <= 0
      $('.bouncing-arrow').not(':animated').fadeIn(500)
      $("#tagline").css(bottom: '-20px')
      $("#tagline").fadeIn(900)
    else
      $('.bouncing-arrow').not(':animated').fadeOut(500)
      $("#tagline").fadeOut(2500)
