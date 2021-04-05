jQuery ($) ->

  $('a#locale_menu').click (e) ->
    e.preventDefault()
    $('#locale_selections').toggle()

  $('.ui-datepicker').datepicker
    inline: true
    numberOfMonths: 2
    showButtonPanel: true
    dateFormat: "DD, MM d, yy"
    constrainInput: true

  $('.ui-datepicker-past-only').datepicker
    inline: true
    numberOfMonths: 1
    showButtonPanel: true
    dateFormat: "DD, MM d, yy"
    constrainInput: true
    maxDate: 0

  $('.ui-datetimepicker').datetimepicker
    dateFormat: "DD, MM d, yy"
    ampm: true

  $("div#purchased_on_picker").datepicker
    altField: "#warranty_registration_purchased_on"
    altFormat: "yy-mm-dd"
    defaultDate: $("div#purchased_on_picker").data('default')
    numberOfMonths: 1
    maxDate: 0

  $('a.c2spinner').on 'click', ->
    column = $('div#column2')
    $(column).html("<img src='#{column.data("loading")}' style='padding: 20px'>")

  $("a.safety-panel-link").click (e) ->
    $("div.safety-panel-instructions").hide()
    $("#safety-content").html(' ')
    $(".spinner").show()

  if jQuery.fn.slick
    $('.reviews-slider').slick
      mobileFirst: true
      slidesToShow: 1
      slidesToScroll: 1
      autoplay: true
      autoplaySpeed: 4000
      responsive: [
        {
          breakpoint: 640
          settings:
            slidesToShow: 1
        },
        {
          breakpoint: 1024,
          settings:
            slidesToShow: 2,
        }
      ]

  $('a.edit-link').click (e) ->
    e.preventDefault()
    $('.dialog').hide()
    $('.popup-form').hide()
    opener = "##{ $(@).data('opener') }"
    $(opener).toggle()

  $('a.cancel-edit').click (e) ->
    e.preventDefault()
    $('.popup-form').hide()

  # hide the text field with the date (don't use a hidden field so we can test the form)
  # $("form#new_warranty_registration #warranty_registration_puchased_on").hide()

  $('a[data-newwindow="true"]').click (e) ->
    e.preventDefault()
    window.open(
      "#{ $(@).data('href') }",
      "newwindow",
      "directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,height=#{ $(@).data('windowheight') },width=#{ $(@).data('windowwidth') }"
    )

  $('a.update-and-play-inline-video').click (e) ->
    e.preventDefault()
    video_url = "https://www.youtube.com/embed/#{ $(@).data('videoid') }?autostart=1&autoplay=1&rel=0"
    $("##{ $(@).data('containerid') } iframe").attr 'src', video_url

  $('a.start-video').click (e) ->
    e.preventDefault()
    if $(@).data('videoid').startsWith('PL')
      video_url = "https://www.youtube.com/embed/videoseries?list=#{ $(@).data('videoid') }"
    else
      video_url = "https://www.youtube.com/embed/#{ $(@).data('videoid') }?autostart=1&autoplay=1&rel=0"

    $('#videoIFrame').attr 'data-src', video_url
    $('#videoModal').foundation 'reveal', 'open'

  $('a.close-video').click (e) ->
    $('#videoModal').foundation 'reveal', 'close'
    $('#videoIFrame').attr('src', '')

  $(".vm-big-button").each ->
    bg = $(@).data('background')
    $(@).css("background-image": "url(#{bg})")

  $('form').on 'click', '.remove_fields', (event) ->
    $(@).closest('div.row').find('input[type=hidden]').val('1')
    $(@).closest('div.row').hide()
    $(".additional_instruction").show()
    event.preventDefault()

