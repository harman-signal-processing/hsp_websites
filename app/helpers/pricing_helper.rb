module PricingHelper

  def calculate_pricing_for_product_page(product, product_promotion)
    @discount_amount = product.calculate_discount_amount(product_promotion)
    @new_price = product.calculate_new_price(@discount_amount)
  end

end
