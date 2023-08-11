var master_product_list = [];
var product_elements_to_show = [];
var product_elements_to_hide = [];
var range_filter_data = {};
var slider_filter_data = {};
var upwards_slider_filter_data = {};

// Each slider element is initialized and given a callback
// function for when the values change.
function initializeRangeSliders() {
  $.each( $("div.slider-range-container"), function() {
    var low_min = $(this).data("low-min");
    var low_max = $(this).data("low-max");
    var high_min = $(this).data("high-min");
    var high_max = $(this).data("high-max");
    var uom = $(this).data("uom");
    var secondary_uom = $(this).data("secondary-uom");
    var secondary_uom_formula = $(this).data("secondary-uom-formula");
    var slider_low = $(this).children("div.slider-range-low");
    var slider_high = $(this).children("div.slider-range-high");
    var range_label = $(this).children("div.range-label");
    var filter_name = $(this).attr("data-filtername");
    var stepsize = $(this).attr("data-stepsize");
    var slider_value_low = low_max;
    var alt_slider_value_low = "";
    var slider_value_high = high_min;
    var alt_slider_value_high = "";

    var session_filter_data = JSON.parse(sessionStorage.getItem('range_filter_data'));
    if (session_filter_data && session_filter_data[filter_name]) {
      range_filter_data[filter_name] = session_filter_data[filter_name];
    } else {
      range_filter_data[filter_name] = {
        default_low: low_max,
        selected_low: low_max,
        default_high: high_min,
        selected_high: high_min
      };
    }

    slider_low.slider({
      range: false,
      min: low_min,
      max: low_max,
      value: range_filter_data[filter_name]["selected_low"],
      step: parseInt(stepsize),
      slide: function(event, ui) {
        slider_value_low = ui.value;
        slider_values = slider_value_low + " - " + slider_value_high + " " + uom;
        if (secondary_uom.length && secondary_uom_formula.length) {
          alt_slider_value_low = eval(ui.value + secondary_uom_formula).toFixed(1);
          slider_values += " / " + alt_slider_value_low + " - " + alt_slider_value_high + " " + secondary_uom;
        }
        range_label.html(slider_values);
      },
      change: function(event, ui) {
        range_filter_data[filter_name]["selected_low"] = ui.value;
        sessionStorage.setItem('range_filter_data', JSON.stringify(range_filter_data));
        performFilter();
      }
    });

    slider_high.slider({
      range: false,
      min: high_min,
      max: high_max,
      value: range_filter_data[filter_name]["selected_high"],
      step: parseInt(stepsize),
      slide: function(event, ui) {
        slider_value_high = ui.value;
        slider_values = slider_value_low + " - " + slider_value_high + " " + uom;
        if (secondary_uom.length && secondary_uom_formula.length) {
          alt_slider_value_high = eval(ui.value + secondary_uom_formula).toFixed(1);
          slider_values += " / " + alt_slider_value_low + " - " + alt_slider_value_high + " " + secondary_uom;
        }
        range_label.html(slider_values);
      },
      change: function(event, ui) {
        range_filter_data[filter_name]["selected_high"] = ui.value;
        sessionStorage.setItem('range_filter_data', JSON.stringify(range_filter_data));
        performFilter();
      }
    });

    // Setting the labels on initialize
    range_label_value = slider_low.slider("value") + " - " + slider_high.slider("value") + " " + uom
    if (secondary_uom.length && secondary_uom_formula.length) {
      alt_slider_value_low = eval(slider_low.slider("value") + secondary_uom_formula).toFixed(1);
      alt_slider_value_high = eval(slider_high.slider("value") + secondary_uom_formula).toFixed(1);
      range_label_value += " / " + alt_slider_value_low + " - " + alt_slider_value_high + " " + secondary_uom;
    }
    range_label.html(range_label_value);

  });
  sessionStorage.setItem('range_filter_data', JSON.stringify(range_filter_data));
}

function initializeSliders() {
  $.each( $("div.slider-number-container"), function() {
    var min = $(this).data("min");
    var max = $(this).data("max");
    var uom = $(this).data("uom");
    var secondary_uom = $(this).data("secondary-uom");
    var secondary_uom_formula = $(this).data("secondary-uom-formula");
    var slider = $(this).children("div.slider-number");
    var number_label = $(this).children("div.number-label");
    var filter_name = $(this).attr("data-filtername");
    var stepsize = $(this).attr("data-stepsize");

    var session_filter_data = JSON.parse(sessionStorage.getItem('slider_filter_data'));
    if (session_filter_data && session_filter_data[filter_name]) {
      slider_filter_data[filter_name] = session_filter_data[filter_name];
    } else {
      slider_filter_data[filter_name] = {
        default: max,
        selected_value: max
      };
    }

    slider.slider({
      range: false,
      min: min,
      max: max,
      value: slider_filter_data[filter_name]["selected_value"],
      step: parseInt(stepsize),
      slide: function(event, ui) {
        slider_value = ui.value + " " + uom;
        if (secondary_uom.length && secondary_uom_formula.length) {
          alt_value = eval(ui.value + secondary_uom_formula).toFixed(1);
          slider_value += " / " + alt_value + " " + secondary_uom;
        }
        number_label.html(slider_value);
      },
      change: function(event, ui) {
        slider_filter_data[filter_name]["selected_value"] = ui.value;
        sessionStorage.setItem('slider_filter_data', JSON.stringify(slider_filter_data));
        performFilter();
      }
    });

    number_label_value = slider.slider("value") + " " + uom
    if (secondary_uom.length && secondary_uom_formula.length) {
      alt_value = eval(slider.slider("value") + secondary_uom_formula).toFixed(1);
      number_label_value += " / " + alt_value + " " + secondary_uom;
    }
    number_label.html(number_label_value);

  });
  sessionStorage.setItem('slider_filter_data', JSON.stringify(slider_filter_data));
}

function initializeUpwardsSliders() {
  $.each( $("div.upwards-slider-number-container"), function() {
    var min = $(this).data("min");
    var max = $(this).data("max");
    var uom = $(this).data("uom");
    var secondary_uom = $(this).data("secondary-uom");
    var secondary_uom_formula = $(this).data("secondary-uom-formula");
    var slider = $(this).children("div.upwards-slider-number");
    var number_label = $(this).children("div.number-label");
    var filter_name = $(this).attr("data-filtername");
    var stepsize = $(this).attr("data-stepsize");

    var session_filter_data = JSON.parse(sessionStorage.getItem('upwards_slider_filter_data'));
    if (session_filter_data && session_filter_data[filter_name]) {
      upwards_slider_filter_data[filter_name] = session_filter_data[filter_name];
    } else {
      upwards_slider_filter_data[filter_name] = {
        default: -1,
        selected_value: -1
      };
    }

    slider.slider({
      range: false,
      min: -1,
      max: max,
      value: upwards_slider_filter_data[filter_name]["selected_value"],
      step: parseInt(stepsize),
      slide: function(event, ui) {
        slider_value = ui.value + " " + uom;
        if ( ui.value == -1 ) {
          slider_value = "any";
        } else if (secondary_uom.length && secondary_uom_formula.length) {
          alt_value = eval(ui.value + secondary_uom_formula).toFixed(1);
          slider_value += " / " + alt_value + " " + secondary_uom;
        }
        number_label.html(slider_value);
      },
      change: function(event, ui) {
        upwards_slider_filter_data[filter_name]["selected_value"] = ui.value;
        sessionStorage.setItem('upwards_slider_filter_data', JSON.stringify(upwards_slider_filter_data));
        performFilter();
      }
    });

    number_label_value = slider.slider("value") + " " + uom
    if ( slider.slider("value") == -1 ) {
      number_label_value = "any";
    } else if (secondary_uom.length && secondary_uom_formula.length) {
      alt_value = eval(slider.slider("value") + secondary_uom_formula).toFixed(1);
      number_label_value += " / " + alt_value + " " + secondary_uom;
    }
    number_label.html(number_label_value);

  });
  sessionStorage.setItem('upwards_slider_filter_data', JSON.stringify(upwards_slider_filter_data));
}

// Adds the given element to the "show" array and removes
// it from the "hide" array
function showProduct(e) {
  var show_index = window.product_elements_to_show.indexOf(e);
  if (show_index === -1) {
    window.product_elements_to_show.push(e);
  }
  var hide_index = window.product_elements_to_hide.indexOf(e);
  if (hide_index > -1) {
    window.product_elements_to_hide.splice(hide_index, 1);
  }
}

// Adds the given element to the "hide" array and removes
// it from the "show" array
function hideProduct(e) {
  var show_index = window.product_elements_to_show.indexOf(e);
  if (show_index > -1) {
    window.product_elements_to_show.splice(show_index, 1);
  }
  var hide_index = window.product_elements_to_hide.indexOf(e);
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

function rangeFilter(item, filter_name, selected_values) {
  // if the slider hasn't moved, return true for all products
  if ( parseFloat(selected_values["selected_low"]) == parseFloat(selected_values["default_low"]) &&
    parseFloat(selected_values["selected_high"]) == parseFloat(selected_values["default_high"]) ) {
      return true;
  } else if ( typeof $(item).attr("data-"+filter_name) !== 'undefined' ) {
    var this_range = $(item).attr("data-"+filter_name).split("-");
    if (parseFloat(this_range[0]) <= selected_values["selected_low"] && parseFloat(this_range[1]) >= selected_values["selected_high"]) {
      return true;
    }
  }
  return false;
}

function sliderFilter(item, filter_name, filter_data) {
  // if the slider hasn't moved, return true for all products
  if ( parseFloat(filter_data["selected_value"]) == parseFloat(filter_data["default"]) ) {
      return true;
  } else if ( typeof $(item).attr("data-"+filter_name) !== 'undefined' ) {
    var this_value = $(item).attr("data-"+filter_name);
    if (this_value <= filter_data['selected_value']) {
      return true;
    }
  }
  return false;
}

function upwardsSliderFilter(item, filter_name, filter_data) {
  // if the slider hasn't moved, return true for all products
  if ( parseFloat(filter_data["selected_value"]) == parseFloat(filter_data["default"]) ) {
      return true;
  } else if ( typeof $(item).attr("data-"+filter_name) !== 'undefined' ) {
    var this_value = $(item).attr("data-"+filter_name);
    if ( filter_data['selected_value'] == 0 ) {
      if ( this_value == 0) {
        return true;
      }
    } else if (this_value >= filter_data['selected_value']) {
      return true;
    }
  } else if (filter_data['selected_value'] == 0) {
    return true;
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
  filterProducts(
    selected_sub_families,
    text_filter_data,
    select_filter_data,
    boolean_filter_data,
    slider_filter_data,
    range_filter_data,
    upwards_slider_filter_data
  );

  sessionStorage.setItem('selected_sub_families', JSON.stringify(selected_sub_families));
  sessionStorage.setItem('text_filter_data', JSON.stringify(text_filter_data));
  sessionStorage.setItem('select_filter_data', JSON.stringify(select_filter_data));
  sessionStorage.setItem('boolean_filter_data', JSON.stringify(boolean_filter_data));
}

function rerunFilter() {
  window.product_elements_to_show = [];
  window.product_elements_to_hide = [];
  var selected_sub_families = JSON.parse(sessionStorage.getItem('selected_sub_families'));
  var text_filter_data = JSON.parse(sessionStorage.getItem('text_filter_data'));
  var select_filter_data = JSON.parse(sessionStorage.getItem('select_filter_data'));
  var boolean_filter_data = JSON.parse(sessionStorage.getItem('boolean_filter_data'));
  var slider_filter_data = JSON.parse(sessionStorage.getItem('slider_filter_data'));
  var upwards_slider_filter_data = JSON.parse(sessionStorage.getItem('upwards_slider_filter_data'));
  var range_filter_data = JSON.parse(sessionStorage.getItem('range_filter_data'));

  // loop through each product
  filterProducts(
    selected_sub_families,
    text_filter_data,
    select_filter_data,
    boolean_filter_data,
    slider_filter_data,
    range_filter_data,
    upwards_slider_filter_data
  );

  // restore input settings from session
  if (selected_sub_families) {
    for (var i = 0; i < selected_sub_families.length; i++) {
      $("input[name='sub_family[]'][val='"+selected_sub_families[i]+"'").prop('checked', true);
    }
  }

  for (var filter_name in text_filter_data) {
    var filter_values = text_filter_data[filter_name];
    for (var i = 0; i < filter_values.length; i++) {
      $("input.text-filter[type='checkbox'][name='"+filter_name+"'][value='"+filter_values[i]+"']").prop('checked', true);
    }
  }

  for (var filter_name in select_filter_data) {
    var filter_value = select_filter_data[filter_name];
    $("select.select-filter[name='"+filter_name+"']").val(filter_value);
  }

  for (var filter_name in boolean_filter_data) {
    var filter_values = boolean_filter_data[filter_name];
    for (var i = 0; i < filter_values.length; i++) {
      $("input.boolean-filter[type='checkbox'][name='"+filter_name+"'][value='"+filter_values[i]+"']").prop('checked', true);
    }
  }
}

function filterProducts(selected_sub_families, text_filter_data, select_filter_data, boolean_filter_data, slider_filter_data, range_filter_data, upwards_slider_filter_data) {
  $.each((master_product_list), function() {
    var failed_filter_count = 0;
    // apply each filter
    if ($("input[name='sub_family[]']").length > 0) {
      if (productFamilyFilter(this, selected_sub_families) == false) {
        failed_filter_count++;
      }
    }

    for (var filter_name in text_filter_data) {
      if (textFilter(this, filter_name, text_filter_data[filter_name]) == false) {
        failed_filter_count++;
      }
    }

    for (var filter_name in select_filter_data) {
      if (selectFilter(this, filter_name, select_filter_data[filter_name]) == false) {
        failed_filter_count++;
      }
    }

    for (var filter_name in boolean_filter_data) {
      if (booleanFilter(this, filter_name, boolean_filter_data[filter_name]) == false) {
        failed_filter_count++;
      }
    }

    for (var filter_name in slider_filter_data) {
      if (sliderFilter(this, filter_name, slider_filter_data[filter_name]) == false) {
        failed_filter_count++;
      }
    }

    for (var filter_name in range_filter_data) {
      if (rangeFilter(this, filter_name, range_filter_data[filter_name]) == false) {
        failed_filter_count++;
      }
    }

    for (var filter_name in upwards_slider_filter_data) {
      if (upwardsSliderFilter(this, filter_name, upwards_slider_filter_data[filter_name]) == false) {
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
  $("#ps-top-nav").on('click', ".ps-start-spinner", function() {
		$("li.product_family_box").removeClass("selected"); //css("outline", "none");
    $(this).parent("li").addClass("selected"); //css("outline", "1px solid #CCC");
    $(".spinner").show();
    $("ul#hidden-products").empty();
    $("#results-container form").empty();
    $("#options-container").empty();
    $("div#subgroups").empty();
    $("div#intro").remove();
    $("div.category-banner").remove();
    sessionStorage.removeItem('range_filter_data');
    sessionStorage.removeItem('slider_filter_data');
    sessionStorage.removeItem('upwards_slider_filter_data');
    $.getScript(this.href);
    history.pushState(null, "", this.href);
    return false;
  });

  $("#ps-sub-nav").on('click', ".ps-start-spinner", function() {
    $("li.subgroup").removeClass("selected"); //css("outline", "none");
    $(this).parent("li").addClass("selected"); //css("outline", "1px solid #CCC");
    $(".spinner").show();
    $("ul#hidden-products").empty();
    $("#results-container form").empty();
    $("#options-container").empty();
    sessionStorage.removeItem('range_filter_data');
    sessionStorage.removeItem('slider_filter_data');
    sessionStorage.removeItem('upwards_slider_filter_data');
    $.getScript(this.href);
    history.pushState(null, "", this.href);
    return false;
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

