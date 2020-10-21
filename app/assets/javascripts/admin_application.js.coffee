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

  $('form.bulk_specifications_update').submit (e) ->
    $(@).find("span:hidden").remove()
    return true

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(@).data('id'), 'g')
    $(@).closest('div.row').before($(@).data('fields').replace(regexp, time))
    $(@).closest('div.system_rule_system_rule_actions_action_type select')
    show_hide_related_actions()
    event.preventDefault()

  $('select.brand-select').change (e) ->
    ps = $("select#product_family_product_product_id")
    ps.empty()
    $.getJSON "/api/v2/brands/#{ $(@).val() }/products.json", (data) ->
      $.each data, (index, item) ->
        opt = new Option item.name, item.id
        ps.append opt
    ps.chosen("destroy").attr(multiple: false)
