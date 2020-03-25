var master_product_list = [];
var product_elements_to_show = [];
var product_elements_to_hide = [];
var slider_filter_data = {};

// Each slider element is initialized and given a callback
// function for when the values change.
function initializeSliders() {
  $.each( $("div.slider-range-container"), function() {
    var min = $(this).data("min");
    var max = $(this).data("max");
    var uom = $(this).data("uom");
    var slider = $(this).children("div.slider-range");
    var input = $(this).children("input");
    var filter_name = $(this).attr("data-filtername");
    slider_filter_data[filter_name] = {
      min: $(this).attr("data-min"),
      max: $(this).attr("data-max"),
      selected_min: $(this).attr("data-min"),
      selected_max: $(this).attr("data-max")
    };
    slider.slider({
      range: true,
      min: min,
      max: max,
      values: [ min, max ],
      //step: ((max - min)/100),
      slide: function(event, ui) {
        input.val( ui.values[0] + " - " + ui.values[1] + " " + uom );
      },
      change: function(event, ui) {
        slider_filter_data[filter_name]["selected_min"] = ui.values[0];
        slider_filter_data[filter_name]["selected_max"] = ui.values[1];
        performFilter();
      }
    });

    input.val( slider.slider("values", 0) + " - " + slider.slider("values", 1) + " " + uom );
  });
}

// Adds the given element to the "show" array and removes
// it from the "hide" array
function showProduct(e) {
  const show_index = window.product_elements_to_show.indexOf(e);
  if (show_index === -1) {
    window.product_elements_to_show.push(e);
  }
  const hide_index = window.product_elements_to_hide.indexOf(e);
  if (hide_index > -1) {
    window.product_elements_to_hide.splice(hide_index, 1);
  }
}

// Adds the given element to the "hide" array and removes
// it from the "show" array
function hideProduct(e) {
  const show_index = window.product_elements_to_show.indexOf(e);
  if (show_index > -1) {
    window.product_elements_to_show.splice(show_index, 1);
  }
  const hide_index = window.product_elements_to_hide.indexOf(e);
  if (hide_index === -1) {
    window.product_elements_to_hide.push(e);
  }
}

// After any filter is executed, this will show/hide the
// results.
function showFilteredProducts() {
  $("ul#product-boxes").empty();
  $("ul#hidden-products").empty();

  window.product_elements_to_show.sort(function(a,b) {
    if ( $(b).data('position') < $(a).data('position')) {
      return 1;
    } else {
      return -1;
    }
  });

  for (i = 0; i < window.product_elements_to_show.length; i++) {
    $("ul#product-boxes").append(window.product_elements_to_show[i]);
  }

  for (j = 0; j < window.product_elements_to_hide.length; j++) {
    $("ul#hidden-products").append(window.product_elements_to_hide[j]);
  }

  if (window.product_elements_to_show.length > 1) {
    $("form#compare_form .button").show();
  } else {
    $("form#compare_form .button").hide();
  }
  if (window.product_elements_to_show.length < 1) {
    $("ul#product-boxes").append("<li>Sorry, no products match your criteria.</li>");
  }
}

// Product Family filters and determine which
// products to show or hide based on product family selection.
function productFamilyFilter(item, selected_sub_families) {
  var this_families = $(item).attr("data-families").split(",");
  for (var i = 0; i < this_families.length; i++) {
    var value = this_families[i];
    if (selected_sub_families.indexOf(value) >= 0) {
      return true;
    }
  }
  return false;
}

function textFilter(item, filter_name, selected_values) {
  if ( typeof $(item).attr("data-"+filter_name) !== 'undefined' ) {
    var this_value = $(item).attr("data-"+filter_name);
    if (selected_values.indexOf(this_value) >= 0) {
      return true;
    }
  }
  return false;
}

function selectFilter(item, filter_name, selected_values) {
  if ( typeof $(item).attr("data-"+filter_name) !== 'undefined' ) {
    var this_value = $(item).attr("data-"+filter_name);
    if (selected_values.indexOf(this_value) >= 0) {
      return true;
    }
  }
  return false;
}

function booleanFilter(item, filter_name, selected_values) {
  if ( typeof $(item).attr("data-"+filter_name) !== 'undefined' ) {
    var this_value = $(item).attr("data-"+filter_name);
    if (selected_values.indexOf(this_value) >= 0) {
      return true;
    }
  // Here we treat empty values for a product as if they were marked 'false'.
  // This may not be desired, but probably makes sense.
  } else if ( selected_values.indexOf("false") >= 0 ) {
    return true;
  }
  return false;
}

function sliderFilter(item, filter_name, selected_values) {
  // if the slider hasn't moved, return true for all products
  if ( parseInt(selected_values["selected_min"]) == parseInt(selected_values["min"]) &&
    parseInt(selected_values["selected_max"]) == parseInt(selected_values["max"]) ) {
      return true;
  } else if ( typeof $(item).attr("data-"+filter_name) !== 'undefined' ) {
    var this_value = $(item).attr("data-"+filter_name);
    // if the value has a dash in it, then consider it a range
    if (this_value.indexOf("-") >= 0) {
      var this_range = this_value.split("-");
      if (parseInt(this_range[0]) >= selected_values["selected_min"] && parseInt(this_range[1]) <= selected_values["selected_max"]) {
        return true;
      }
    } else if (this_value >= selected_values["selected_min"] && this_value <= selected_values["selected_max"]) {
      return true;
    }
  }
  return false;
}

function performFilter() {
  window.product_elements_to_show = [];
  window.product_elements_to_hide = [];
  var selected_sub_families = [];
  var text_filter_data = {};
  var select_filter_data = {};
  var boolean_filter_data = {};

  // figure out which product families are selected
  $("input[name='sub_family[]']:checked").each(function() {
    selected_sub_families.push(this.value);
  });

  // if no families are selected, pretend they're all selected
  if (selected_sub_families.length == 0) {
    $("input[name='sub_family[]']").each(function() {
      selected_sub_families.push(this.value);
    });
  }

  // build data of other filter checkbox inputs
  $.each($("input.text-filter[type='checkbox']:checked"), function() {
    var filter_name = $(this).attr("name");
    text_filter_data[filter_name] = text_filter_data[filter_name] || [];
    text_filter_data[filter_name].push( $(this).val() );
  });

  // build data of select inputs
  $.each($("select.select-filter"), function() {
    var filter_name = $(this).attr("name");
    var selected_value = $(this).val();
    if (selected_value.length) {
      select_filter_data[filter_name] = selected_value;
    }
  });

  // build data for boolean inputs
  $.each($("input.boolean-filter[type='checkbox']:checked"), function() {
    var filter_name = $(this).attr("name");
    boolean_filter_data[filter_name] = boolean_filter_data[filter_name] || [];
    boolean_filter_data[filter_name].push( $(this).val() );
  });

  // loop through each product
  $.each((master_product_list), function() {
    var failed_filter_count = 0;
    // apply each filter
    if ($("input[name='sub_family[]']").length > 0) {
      if (productFamilyFilter(this, selected_sub_families) == false) {
        failed_filter_count++;
      }
    }

    for (const filter_name in text_filter_data) {
      if (textFilter(this, filter_name, text_filter_data[filter_name]) == false) {
        failed_filter_count++;
      }
    }

    for (const filter_name in select_filter_data) {
      if (selectFilter(this, filter_name, select_filter_data[filter_name]) == false) {
        failed_filter_count++;
      }
    }

    for (const filter_name in boolean_filter_data) {
      if (booleanFilter(this, filter_name, boolean_filter_data[filter_name]) == false) {
        failed_filter_count++;
      }
    }

    for (const filter_name in slider_filter_data) {
      if (sliderFilter(this, filter_name, slider_filter_data[filter_name]) == false) {
        failed_filter_count++;
      }
    }

    if (failed_filter_count > 0) {
      hideProduct(this);
    } else {
      showProduct(this);
    }

  });

  showFilteredProducts();
}

jQuery(function($) {
  $(".ps-start-spinner").click(function() {
    $(".spinner").show();
    $("#results-container form").empty();
    $("#options-container").empty();
  });

  // Observe the form containing all the filters and
  // loop through each product whenever a filter is clicked
  $("#options-container").on('click', 'form#filters input', function() {
    performFilter();
  });
  $("#options-container").on('change', 'form#filters select', function() {
    performFilter();
  });

});

