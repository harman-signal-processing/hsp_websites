jQuery ($) ->

  window.pinner = -> $('#system_summary_container ').pin
    containerSelector: $('#configurator-form-container')
    padding: {top: 100}
  window.pinner()

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

  # Action when clicking the "add another" option link
  $("a.option-adder").click (e) ->
    e.preventDefault()
    timestamp = new Date().getTime()
    option_id = $(@).data('option-id')
    $container = $("#system_option_#{ $(@).data('option-id') }_container")

    $elem = $container.find('div.select:first').clone()
    original_id = $elem.attr('id')
    $elem.attr('id', "#{original_id}_#{timestamp}")
    $elem.insertBefore $(@).closest("div.container")
    window.pinner()

    $container.find("a.option-remover").show() if $container.find("div.select").size() > 1

  # Action when clicking the "remove last option" link
  $("a.option-remover").click (e) ->
    e.preventDefault()
    option_id = $(@).data('option-id')
    $container = $("#system_option_#{ option_id }_container")

    $container.find('div.select:last').remove()
    window.pinner()
    $container.find('select:first').trigger 'change'
    $(@).hide() if $container.find("div.select").size() < 2


  # Hide all "remove last options" link on page load
  $("a.option-remover").hide()

  # The 'multiple: true' is used to make rails add the [] to the parameter
  # name, but we want to display the multiple options as separate
  # drop-downs, so we set the "multiple" attribute to false so the HTML
  # is rendered as individual selects.
  $(".un-multiply").attr("multiple", false)
