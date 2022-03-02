class CheckoutController < ApplicationController
  include CurrentShoppingCart
  before_action :set_locale
  before_action :set_cart, except: [:shopper_redirect] # Don't set cart in the session if we're redirecting to a sales order
  before_action :authenticate_user!, only: [:new, :shopper_redirect, :success]
  before_action :set_address, only: [:new, :save_address]
  skip_before_action :verify_authenticity_token, only: [:get_payment_methods, :initiate_payment]

  # Before checking out, let's signin/create our user so we can
  # assign the order to them after the Adyen dropin process is
  # complete
  def new
  end

  def save_address
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to checkout_payment_path }
      else
        format.html { render action: "new", alert: "Please check your billing address for errors." }
      end
    end
  end

  def payment
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
    @sales_order = SalesOrder.new(user: current_user, shopping_cart: @shopping_cart, address: current_user.addresses.last)
    respond_to do |format|
      if @sales_order.save
        session.delete(:shopping_cart_id)
        format.html { redirect_to @sales_order, notice: "Success! Thank you for your order. See the details below." }
      else
        format.html { redirect_to profile_path, alert: "We're sorry, there was a problem with your order. Please contact us using our support page." }
      end
    end
  end

  def pending
    redirect_to profile_path, notice: "Your payment is currently pending. Watch your email and check back here to see your completed order details."
  end

  def failed
    redirect_to checkout_payment_path, alert: "The order failed. Please try a different method of payment."
  end

  def error
    redirect_to checkout_payment_path, alert: "There was an error. Please try a different method of payment."
  end

  private

  def set_address
    @address = current_user.default_address
    @address.addressable_type = "User"
    @address.addressable_id = current_user.id
  end

  def address_params
    params.require(:address).permit(
      :street_1, :street_2, :street_3, :street_4,
      :locality, :region, :postal_code, :country
    )
  end
end
