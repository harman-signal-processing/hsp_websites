module ProductSelectorHelper

  def filter_input_for(product_filter, product_family)
    if product_filter.is_boolean?
      boolean_filter_input(product_filter)
    elsif product_filter.is_number? || product_filter.is_range?
      number_or_range_filter_input(product_filter, product_family)
    else
      text_filter_input(product_filter, product_family)
    end
  end

  def filter_title(product_filter)
    content_tag(:h5, product_filter.name)
  end

  def boolean_filter_input(product_filter)
    filter_title(product_filter) +
    label_tag do
      check_box_tag("filter-#{product_filter.to_param}",
                    true,
                    false,
                    id: "filter-#{product_filter.to_param}_true",
                    class: "boolean-filter") + " Yes"
    end +
    label_tag do
      check_box_tag("filter-#{product_filter.to_param}",
                    false,
                    false,
                    id: "filter-#{product_filter.to_param}_false",
                    class: "boolean-filter") + " No"
    end
  end

  def number_or_range_filter_input(product_filter, product_family)
    filter_title(product_filter) +
    content_tag(:div,
      class: "slider-range-container",
      id: "filter_#{ product_filter.to_param }_slider",
      data: {
        filtername: "filter-#{product_filter.to_param}",
        min: product_filter.min_value_for(product_family),
        max: product_filter.max_value_for(product_family),
        stepsize: product_filter.stepsize.present? ? product_filter.stepsize : 1,
        uom: product_filter.uom.present? ? product_filter.uom : "",
        secondary_uom: product_filter.secondary_uom.present? ? product_filter.secondary_uom : "",
        secondary_uom_formula: product_filter.secondary_uom_formula.present? ? product_filter.secondary_uom_formula : ""
      }) do
      content_tag(:div, "", class: "slider-range") +
      #text_field_tag("filter-#{product_filter.to_param}", "", class: "unstyled slider-filter") +
      content_tag(:div, "", class: "range-label")
    end
  end

  def text_filter_input(product_filter, product_family)
    unique_values = product_filter.unique_values_for(product_family)
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
          id: "filter-#{product_filter.to_param}_#{val.to_param}" ) + " #{val}"
      end
    end.join.html_safe
  end

end
