var  master_product_list = [];
var  product_elements_to_show = [];
var  product_elements_to_hide = [];

// Each slider element is initialized and given a callback
// function for when the values change.
function initializeSliders() {
  $.each( $("div.slider-range-container"), function() {
    var min = $(this).data("min");
    var max = $(this).data("max");
    var uom = $(this).data("uom");
    var slider = $(this).children("div.slider-range");
    var input = $(this).children("input");
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

function performFilter() {
  window.product_elements_to_show = [];
  window.product_elements_to_hide = [];
  selected_sub_families = [];

  $("input[name='sub_family[]']:checked").each(function() {
    selected_sub_families.push(this.value);
  });
  // if no families are selected, pretend they're all selected
  if (selected_sub_families.length == 0) {
    $("input[name='sub_family[]']").each(function() {
      selected_sub_families.push(this.value);
    });
  }

  // loop through each product
  $.each((master_product_list), function() {
    var failed_filter_count = 0;
    // apply each filter
    if ($("input[name='sub_family[]']").length > 0) {
      if (productFamilyFilter(this, selected_sub_families) == false) {
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

  // Observe checkbox-style filters and determine which
  // products to show or hide.
  $("#options-container").on('click', 'form#filters input.text-filter[type="checkbox"]', function(){
    var filter_name = $(this).attr("name");
    var selected_values = [];
    $.each($("input[name='" + filter_name + "']:checked"), function() {
      selected_values.push($(this).val());
    });
    console.log("Checked something: " + selected_values);
  });

  // Observe the form containing all the filters and
  // loop through each product whenever a filter is clicked
  $("#options-container").on('click', 'form#filters', function() {
    performFilter();
  });

});

