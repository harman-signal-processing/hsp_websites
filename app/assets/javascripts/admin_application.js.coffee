jQuery ($) ->
  $('.limited').each ->
    charlimit = $(@).data('charlimit')

    opts =
      maxCharacterSize: charlimit
      originalStyle: 'hint'
      warningStyle: 'warning'
      warningNumber: 5
      displayFormat: "#input characters (#left remaining)"

    $(@).textareaCount(opts)

  show_related_actions = (el) ->
    selected_option = $(el).val()
    $(el).parentsUntil('.rule-action-params').find('.action-option').each ->
      if selected_option in $(@).data('related').split(',') then $(@).show() else $(@).hide()

  show_hide_related_actions = ->
    $('div.system_rule_system_rule_actions_action_type select').each ->
      show_related_actions(@)
      $(@).change -> show_related_actions(@)

  show_hide_related_actions()
  $(".additional_instruction").hide()

  $('form').on 'click', '.remove_fields', (event) ->
    $(@).closest('div.row').find('input[type=hidden]').val('1')
    $(@).closest('div.row').hide()
    $(".additional_instruction").show()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(@).data('id'), 'g')
    $(@).closest('div.row').before($(@).data('fields').replace(regexp, time))
    $(@).closest('div.system_rule_system_rule_actions_action_type select')
    show_hide_related_actions()
    event.preventDefault()

