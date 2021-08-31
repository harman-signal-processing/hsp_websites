module ProductSelectorHelper

  def filter_input_for(product_filter, product_family)
    if product_filter.is_boolean?
      boolean_filter_input(product_filter)
    elsif product_filter.is_number?
      number_filter_input(product_filter, product_family)
    elsif product_filter.is_range?
      range_filter_input(product_filter, product_family)
    else
      text_filter_input(product_filter, product_family)
    end
  end

  def filter_title(product_filter)
    content_tag(:h5) do
      ((product_filter.is_number? && !product_filter.name.to_s.match(/^max/i) && !product_filter.value_type.match?(/upward/i)) ?
        "Max #{product_filter.name}" : product_filter.name)
    end
  end

  def boolean_filter_input(product_filter)
    filter_title(product_filter) +
    label_tag do
      check_box_tag("filter-#{product_filter.to_param}",
                    true,
                    false,
                    id: "filter-#{product_filter.to_param}_true",
                    autocomplete: 'off',
                    class: "boolean-filter") + " Yes"
    end +
    label_tag do
      check_box_tag("filter-#{product_filter.to_param}",
                    false,
                    false,
                    id: "filter-#{product_filter.to_param}_false",
                    autocomplete: 'off',
                    class: "boolean-filter") + " No"
    end
  end

  def number_filter_input(product_filter, product_family)
    slider_type = product_filter.value_type.match?(/upward/i) ?
      "upwards-slider-number" : "slider-number"

    filter_title(product_filter) +
    content_tag(:div,
      class: "#{ slider_type }-container",
      id: "filter_#{ product_filter.to_param }_slider",
      data: {
        filtername: "filter-#{product_filter.to_param}",
        min: product_filter.min_value_for(product_family, website),
        max: product_filter.max_value_for(product_family, website),
        stepsize: product_filter.stepsize_for(product_family, website),
        uom: product_filter.uom.present? ? product_filter.uom : "",
        secondary_uom: product_filter.secondary_uom.present? ? product_filter.secondary_uom : "",
        secondary_uom_formula: product_filter.secondary_uom_formula.present? ? product_filter.secondary_uom_formula : ""
      }) do
      content_tag(:div, "", class: slider_type) +
      #text_field_tag("filter-#{product_filter.to_param}", "", class: "unstyled slider-filter") +
      content_tag(:div, "", class: "number-label")
    end
  end

  def range_filter_input(product_filter, product_family)
    filter_title(product_filter) +
    content_tag(:div,
      class: "slider-range-container",
      id: "filter_#{ product_filter.to_param }_slider",
      data: {
        filtername: "filter-#{product_filter.to_param}",
        low_min: product_filter.min_range_for(product_family, website).first,
        low_max: product_filter.min_range_for(product_family, website).last,
        high_min: product_filter.max_range_for(product_family, website).first,
        high_max: product_filter.max_range_for(product_family, website).last,
        stepsize: product_filter.stepsize_for(product_family, website),
        uom: product_filter.uom.present? ? product_filter.uom : "",
        secondary_uom: product_filter.secondary_uom.present? ? product_filter.secondary_uom : "",
        secondary_uom_formula: product_filter.secondary_uom_formula.present? ? product_filter.secondary_uom_formula : ""
      }) do
      content_tag(:label, "Low") +
      content_tag(:div, "", class: "slider-range-low") +
      content_tag(:label, "High") +
      content_tag(:div, "", class: "slider-range-high") +
      content_tag(:div, "", class: "range-label")
    end
  end

  def text_filter_input(product_filter, product_family)
    unique_values = product_filter.unique_values_for(product_family, website)
    case
      when unique_values.size > 20
        select_filter_input(product_filter, unique_values)
      when (1..19) === unique_values.size
        checkbox_filter_input(product_filter, unique_values)
    end
  end

  def select_filter_input(product_filter, unique_values)
    filter_title(product_filter) +
      select_tag("filter-#{product_filter.to_param}",
                 options_for_select([[]] + unique_values.map{|o| [o.to_param, o]}),
                 class: "select-filter"
      ).html_safe
  end

  def checkbox_filter_input(product_filter, unique_values)
    filter_title(product_filter) +

    unique_values.map do |val|
      label_tag do
        check_box_tag("filter-#{product_filter.to_param}",
          val,
          false,
          class: "text-filter",
          autocomplete: 'off',
          id: "filter-#{product_filter.to_param}_#{val.to_param}" ) + " #{val}"
      end
    end.join.html_safe
  end

end
