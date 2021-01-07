class CheckoutController < ApplicationController
  include CurrentShoppingCart
  before_action :set_locale
  before_action :set_cart, except: [:shopper_redirect] # Don't set cart in the session if we're redirecting to a sales order
  before_action :authenticate_user!, only: [:new, :shopper_redirect, :success]

  # Before checking out, let's signin/create our user so we can
  # assign the order to them after the Adyen dropin process is
  # complete
  def new
  end

  # JS
  def get_payment_methods
    pm = @shopping_cart.get_payment_methods
    render json: pm.response, status: pm.status
  end

  # JS
  def initiate_payment
    response = @shopping_cart.make_payment(
      params["paymentMethod"],
      params["browserInfo"],
      request.remote_ip,
      request.base_url,
      shopper_redirect_url(uuid: @shopping_cart.uuid)
    )

    render json: response.response, status: response.status
  end

  # If Adyen takes the user elsewhere and then needs to return them, this
  # is where they land:
  def shopper_redirect
    begin
      shopping_cart = ShoppingCart.where(uuid: params[:uuid]).first_or_initialize
      if shopping_cart.sales_order
        redirect_to shopping_cart.sales_order and return
      else
        redirect_to profile_path and return
      end
    rescue
      redirect_to profile_path and return
    end
  end

  # The payment went through, create the sales order and redirect the user there.
  # TODO: verify the shopping_cart response_data before creating the sales order
  def success
    @sales_order = SalesOrder.create(user: current_user, shopping_cart: @shopping_cart)
    session.delete(:shopping_cart_id)

    respond_to do |format|
      format.html { redirect_to @sales_order, notice: "Success! Thank you for your order. See the details below." }
    end
  end

  def pending
    redirect_to profile_path, notice: "Your payment is currently pending. Watch your email and check back here to see your completed order details."
  end

  def failed
    redirect_to checkout_path, alert: "The order failed. Please try a different method of payment."
  end

  def error
    redirect_to checkout_path, alert: "There was an error. Please try a different method of payment."
  end

end
