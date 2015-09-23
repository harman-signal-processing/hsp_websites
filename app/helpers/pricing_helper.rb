module PricingHelper

  def calculate_pricing_for_product_page(product, promo)
    @discount_amount = calculate_discount_amount(product, promo)
    @new_price = calculate_new_price(product, @discount_amount)
  end

  # Calculates the discount amount to show on the product page. Takes
  # into account the current promotion, sale price, street price and msrp
  def calculate_discount_amount(product, promo)
    if promo && promo.discount.to_f > 0.0
      calculate_promotion_discount(product, promo)
    elsif product.sale_price && product.sale_price.to_f > 0.0

      if product.street_price.to_f > product.sale_price.to_f
        product.street_price.to_f - product.sale_price.to_f
      elsif !!!(product.street_price.to_f > 0.0) && product.msrp.to_f > product.sale_price.to_f
        product.msrp.to_f - product.sale_price.to_f
      else
        0.0
      end

    else
      0.0
    end
  end

  # Calculates the discount amount to show on the product page. Only
  # takes into account the promotion, street price and msrp
  def calculate_promotion_discount(product, promo)
    case promo.discount_type
    when '$'
      promo.discount.to_f
    when '%'
      if product.street_price.to_f > 0.0
        product.street_price.to_f * (promo.discount / 100)
      elsif product.msrp.to_f > 0.0
        product.msrp.to_f * (promo.discount / 100)
      else
        0.0
      end
    else
      0.0
    end
  end

  # Calculates the new price to show based on the provided discount
  def calculate_new_price(product, discount_amount)
    if discount_amount.to_f > 0.0
      if product.street_price.to_f > 0.0
        product.street_price.to_f - discount_amount.to_f
      elsif product.msrp.to_f > 0.0
        product.msrp.to_f - discount_amount.to_f
      else
        false
      end
    else
      false
    end
  end

end
