CustomizableAttributeValue.destroy_all
ProductFamilyCustomizableAttribute.destroy_all
CustomizableAttribute.destroy_all

horn_dispersion = CustomizableAttribute.where(name: "Horn Dispersion").first_or_create
horn_orientation = CustomizableAttribute.where(name: "Horn Orientation").first_or_create
weatherization = CustomizableAttribute.where(name: "Weatherization").first_or_create
color = CustomizableAttribute.where(name: "Color").first_or_create
transformer = CustomizableAttribute.where(name: "Transformer", comment: "Requires discussion with HARMAN to determine type. Upcharge dependent on type.").first_or_create
crossover_mode = CustomizableAttribute.where(name: "Crossover Mode").first_or_create
transformer2 = CustomizableAttribute.where(name: "Transformer", comment: "For weatherized models only").first_or_create
xdriver = CustomizableAttribute.where(name: "X-Driver", comment: "Based on 2432H driver: No ferrofluid, add back plate, for extremely cold temperatures").first_or_create
crossover_mode2 = CustomizableAttribute.where(name: "Crossover Mode", comment: "For weatherized models only").first_or_create

# product families get assigned those attributes:
#
family = ProductFamily.find "ae-series-compact-models-5-to-8-lf"
family.customizable_attributes = [horn_dispersion, horn_orientation, weatherization, color, transformer]
family.save

family.current_products_plus_child_products(family.brand.default_website).each do |product|
  next if product == Product.find("ac15")
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRC (IP55)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRX (IP56)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Black (RAL9004)", code: "BK", comment: "default for non-weatherized", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "White (RAL9010)", code: "WH", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Light Gray (~RAL7035)", code: "GR", comment: "default for WRX & WRC models", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Custom", code: "custom", comment: "Upcharge of up to 25% dependent on RAL# and quantity. Requires approval and additional lead time.", product_id: product.id).first_or_create
  unless product.name.to_s.match(/AC16/)
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer, value: "none", product_id: product.id).first_or_create
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer, value: "100w70v", code: "T100", product_id: product.id).first_or_create
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer, value: "200w70v", code: "T200", product_id: product.id).first_or_create
    unless product.name.to_s.match(/AC26/)
      product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_orientation, value: "Standard", product_id: product.id).first_or_create
      product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_orientation, value: "Rotated", code: "H", product_id: product.id).first_or_create
    end
  end
end


family = ProductFamily.find "ae-application-engineered-original-series"
family.customizable_attributes = [horn_dispersion, horn_orientation, weatherization, color, crossover_mode, transformer2, xdriver]
family.save
subs = ProductFamily.find "subwoofers-c78b96cf-169e-4613-8d60-15406ef67118"
family.current_products_plus_child_products(family.brand.default_website).each do |product|
  next if product.product_families.include?(subs)
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRC (IP55)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRX (IP56)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Black (RAL9004)", code: "BK", comment: "default for non-weatherized", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "White (RAL9010)", code: "WH", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Light Gray (~RAL7035)", code: "GR", comment: "default for WRX & WRC models", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Custom", code: "custom", comment: "Upcharge of up to 25% dependent on RAL# and quantity. Requires approval and additional lead time.", product_id: product.id).first_or_create
  if product.name.to_s.match(/26|64|95/)
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_orientation, value: "Standard", product_id: product.id).first_or_create
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_orientation, value: "Rotated", code: "H", product_id: product.id).first_or_create
  end
  if product.name.to_s.match(/AM7315/)
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode, value: "Bi-Amp", code: "BA", comment: "default for AM7315", product_id: product.id).first_or_create
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode, value: "Tri-Amp", code: "TA", product_id: product.id).first_or_create
  else
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode, value: "Full Range Passive", code: "FR", product_id: product.id).first_or_create
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode, value: "Bi-Amp", code: "BA", product_id: product.id).first_or_create
  end
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer2, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer2, value: "100w70v", code: "T100", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer2, value: "200w70v", code: "T200", product_id: product.id).first_or_create
  if product.name.to_s.match(/AM7200|AM7212|AM7215|AM7315/)
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: xdriver, value: "none", product_id: product.id).first_or_create
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: xdriver, value: "X-Driver", code: "X", product_id: product.id).first_or_create
  end
end


family = ProductFamily.find "subwoofers-c78b96cf-169e-4613-8d60-15406ef67118"
family.customizable_attributes = [weatherization, color]
family.save
family.current_products_plus_child_products(family.brand.default_website).each do |product|
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRC (IP55)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRX (IP56)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Black (RAL9004)", code: "BK", comment: "default for non-weatherized", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "White (RAL9010)", code: "WH", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Light Gray (~RAL7035)", code: "GR", comment: "default for WRX & WRC models", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Custom", code: "custom", comment: "Upcharge of up to 25% dependent on RAL# and quantity. Requires approval and additional lead time.", product_id: product.id).first_or_create
end

family = ProductFamily.find "awc-compact-aw-series-all-weather"
family.customizable_attributes = [horn_dispersion, color, xdriver]
family.save
family.current_products_plus_child_products(family.brand.default_website).each do |product|
  unless product.name.to_s.match(/AWC/)
    if product.name.to_s.match(/AW526/)
      product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_dispersion, value: "120⁰ H, 60⁰ V", code: "/26", comment: "Standard", product_id: product.id).first_or_create
    else
      product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_dispersion, value: "120⁰ H, 60⁰ V", code: "/26", product_id: product.id).first_or_create
    end
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_dispersion, value: "60⁰ H, 40⁰ V", code: "/64", product_id: product.id).first_or_create
    if product.name.to_s.match(/AW266|AW566/)
      product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_dispersion, value: "60⁰ H, 60⁰ V", code: "/66", comment: "Standard", product_id: product.id).first_or_create
    else
      product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_dispersion, value: "60⁰ H, 60⁰ V", code: "/66", product_id: product.id).first_or_create
    end
    if product.name.to_s.match(/AW295|AW595/)
      product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_dispersion, value: "90⁰ H, 50⁰ V", code: "/95", comment: "Standard", product_id: product.id).first_or_create
    else
      product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_dispersion, value: "90⁰ H, 50⁰ V", code: "/95", product_id: product.id).first_or_create
    end
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_dispersion, value: "100⁰ H, 100⁰ V", code: "/99", product_id: product.id).first_or_create
  end
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Black (RAL9004)", code: "BK", comment: "Standard", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "White (RAL9010)", code: "WH", comment: "Custom Shop", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Light Gray (~RAL7035)", code: "GR", comment: "Standard", product_id: product.id).first_or_create
  unless product.name.to_s.match(/AWC/)
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: xdriver, value: "none", product_id: product.id).first_or_create
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: xdriver, value: "X-Driver", code: "X", product_id: product.id).first_or_create
  end
end


family = ProductFamily.find "cwt-wide-coverage"
family.customizable_attributes = [weatherization, color]
family.save
family.current_products_plus_child_products(family.brand.default_website).each do |product|
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRC (IP55)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRX (IP56)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Black (RAL9004)", code: "BK", comment: "default for non-weatherized", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "White (RAL9010)", code: "WH", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Light Gray (~RAL7035)", code: "GR", comment: "default for WRX & WRC models", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Custom", code: "custom", comment: "Upcharge of up to 25% dependent on RAL# and quantity. Requires approval and additional lead time.", product_id: product.id).first_or_create
end


family = ProductFamily.find "pd500-series-large-format"
family.customizable_attributes = [horn_orientation, weatherization, color, transformer2, xdriver]
family.save
family.current_products_plus_child_products(family.brand.default_website).each do |product|
  if product.name.to_s.match(/PD595|PD564/)
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_orientation, value: "Standard", product_id: product.id).first_or_create
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_orientation, value: "Rotated", code: "H", product_id: product.id).first_or_create
  end
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRC (IP55)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRX (IP56)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Black (RAL9004)", code: "BK", comment: "default for non-weatherized", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "White (RAL9010)", code: "WH", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Light Gray (~RAL7035)", code: "GR", comment: "default for WRX & WRC models", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Custom", code: "custom", comment: "Upcharge of up to 25% dependent on RAL# and quantity. Requires approval and additional lead time.", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer2, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer2, value: "100w70v", code: "T100", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer2, value: "200w70v", code: "T200", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: xdriver, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: xdriver, value: "X-Driver", code: "X", product_id: product.id).first_or_create
end


family = ProductFamily.find "pd700i-series-precision-directivity-dual-trap"
family.customizable_attributes = [horn_orientation, weatherization, color, transformer2, xdriver]
family.save
family.current_products_plus_child_products(family.brand.default_website).each do |product|
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_orientation, value: "Standard", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_orientation, value: "Rotated", code: "H", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRC (IP55)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRX (IP56)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Black (RAL9004)", code: "BK", comment: "default for non-weatherized", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "White (RAL9010)", code: "WH", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Light Gray (~RAL7035)", code: "GR", comment: "default for WRX & WRC models", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Custom", code: "custom", comment: "Upcharge of up to 25% dependent on RAL# and quantity. Requires approval and additional lead time.", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer2, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer2, value: "100w70v", code: "T100", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer2, value: "200w70v", code: "T200", product_id: product.id).first_or_create
  if product.name.to_s.match(/215/)
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode2, value: "Passive", code: "FR", product_id: product.id).first_or_create
  else
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode2, value: "Passive", code: "FR", comment: "default for #{product.name}", product_id: product.id).first_or_create
  end
  if product.name.to_s.match(/PD743i-215/)
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode2, value: "Bi-Amp", code: "BA", comment: "default for #{product.name}", product_id: product.id).first_or_create
  else
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode2, value: "Bi-Amp", code: "BA", product_id: product.id).first_or_create
  end
  if product.name.to_s.match(/215/)
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode2, value: "Tri-Amp", code: "TA", product_id: product.id).first_or_create
  end
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: xdriver, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: xdriver, value: "X-Driver", code: "X", product_id: product.id).first_or_create
end


family = ProductFamily.find "pd6000-series-precision-directivity"
family.customizable_attributes = [horn_dispersion, horn_orientation, weatherization, color, crossover_mode2, xdriver]
family.save
family.current_products_plus_child_products(family.brand.default_website).each do |product|
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_orientation, value: "Standard", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: horn_orientation, value: "Rotated", code: "H", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRC (IP55)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRX (IP56)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Black (RAL9004)", code: "BK", comment: "default for non-weatherized", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "White (RAL9010)", code: "WH", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Light Gray (~RAL7035)", code: "GR", comment: "default for WRX & WRC models", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Custom", code: "custom", comment: "Upcharge of up to 25% dependent on RAL# and quantity. Requires approval and additional lead time.", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer2, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer2, value: "100w70v", code: "T100", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: transformer2, value: "200w70v", code: "T200", product_id: product.id).first_or_create
  if product.name.to_s.match(/PD6200|PD6212/)
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode2, value: "Full Range Passive", code: "FR", comment: "default for #{product.name}", product_id: product.id).first_or_create
  else
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode2, value: "Full Range Passive", code: "FR", product_id: product.id).first_or_create
  end
  if product.name.to_s.match(/PD6322/)
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode2, value: "Bi-Amp", code: "BA", comment: "default for #{product.name}", product_id: product.id).first_or_create
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode2, value: "Tri-Amp", code: "TA", product_id: product.id).first_or_create
  else
    product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: crossover_mode2, value: "Bi-Amp", code: "BA", product_id: product.id).first_or_create
  end
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: xdriver, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: xdriver, value: "X-Driver", code: "X", product_id: product.id).first_or_create
end


family = ProductFamily.find "vlai-series-large-format"
family.customizable_attributes = [color, weatherization, xdriver]
family.save
family.current_products_plus_child_products(family.brand.default_website).each do |product|
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Black (RAL9004)", code: "BK", comment: "default for non-weatherized", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "White (RAL9010)", code: "WH", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Light Gray (~RAL7035)", code: "GR", comment: "default for WRX & WRC models", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: color, value: "Custom", code: "custom", comment: "Upcharge of up to 25% dependent on RAL# and quantity. Requires approval and additional lead time.", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRC (IP55)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: weatherization, value: "WRX (IP56)", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: xdriver, value: "none", product_id: product.id).first_or_create
  product.customizable_attribute_values << CustomizableAttributeValue.where( customizable_attribute: xdriver, value: "X-Driver", code: "X", product_id: product.id).first_or_create
end

