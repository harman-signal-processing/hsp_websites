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

  $('#scheduled_task_action_field_name').change (e) ->
    scheduled_task_id = $('#scheduled_task_action_scheduled_task_id').val()
    field_name = $(@).val()
    $.ajax
      url: "/admin/scheduled_tasks/#{scheduled_task_id}/value_field/#{ field_name }"
      delayType: 'script'

  $('.toggler').click (e) ->
    toggle_id = $(@).data('toggle')
    $("##{ toggle_id }_show").toggle()
    $("##{ toggle_id }_hide").toggle()
    if $(@).data('editor')
      editor_id = $(@).data('editor')
      editor = $("##{ editor_id }")
      if editor.hasClass('mceEditor')
        editor.removeClass('mceEditor')
        tinymce.EditorManager.execCommand('mceRemoveEditor', true, editor_id)
      else
        editor.addClass('mceEditor')
        tinymce.EditorManager.execCommand('mceAddEditor', true, editor_id)
    e.preventDefault()

