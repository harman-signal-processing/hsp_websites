class EcommerceMailer < ActionMailer::Base

  def order_confirmation
    @sales_order = params[:sales_order]

    mail(to: @sales_order.user.email,
         subject: "Your #{ @sales_order.brand.name } Order #{ @sales_order.number }",
         from: @sales_order.brand.support_email)
  end

  def low_stock
    @product_stock_subscription = params[:product_stock_subscription]
    @product = @product_stock_subscription.product

    mail(to: @product_stock_subscription.user.email,
         subject: "Low stock alert: #{ @product.name }",
         from: @product.brand.support_email )
  end

end

