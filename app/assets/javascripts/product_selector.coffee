# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

jQuery ($) ->
  $(".ps-start-spinner").click ->
    $(".spinner").show()
    $("#results-container form").empty()
    $("#options-container").empty()

  $("#options-container").on 'click', 'form#filters input[type="checkbox"]', ->

    product_elements_to_show = []
    product_elements_to_hide = []
    selected_sub_families = []
    $("input[name='sub_family[]']:checked").each ->
      selected_sub_families.push @.value

    # If no families are selected, pretend they're all selected
    if selected_sub_families.length == 0
      $("input[name='sub_family[]']").each ->
        selected_sub_families.push @.value

    $("li.product-list-item").each ->
      this_families = $(@).attr("data-families").split(",")
      if (true for value in this_families when value in selected_sub_families).length > 0
        product_elements_to_show.push @
      else
        product_elements_to_hide.push @

    product_elements_to_show.sort (a,b) ->
      if $(b).data('position') < $(a).data('position')
        1
      else
        -1

    $("ul#product-boxes").empty()
    $("ul#hidden-products").empty()

    for p in product_elements_to_show
      $("ul#product-boxes").append(p)

    for p in product_elements_to_hide
      $("ul#hidden-products").append(p)

