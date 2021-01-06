require "adyen-ruby-api-library"

class ShoppingCart < ApplicationRecord
  has_many :line_items, dependent: :nullify
  serialize :payment_data, JSON
  before_create :set_uuid

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def add_item(product)
    current_line_item = line_items.find_by(product_id: product.id)

    if current_line_item
      current_line_item.increment!(:quantity)
    else
      LineItem.create!(product_id: product.id, shopping_cart: self)
    end
  end

  def remove_item(product)
    current_line_item = line_items.find_by(product_id: product.id)

    if current_line_item
      current_line_item.destroy
    end
  end

  def empty?
    !(line_items.length > 0)
  end

  def subtotal
    line_items.inject(0.0){|t,i| t += i.subtotal}
  end

  def subtotal_cents
    (self.subtotal * 100).to_i
  end

  def total
    subtotal + tax
  end

  def total_cents
    (self.total * 100).to_i
  end

  def tax
    0.0
  end

  def total_items
    line_items.inject(0){|t,i| t += i.quantity}
  end

  def has_digital_downloads?
    line_items.map{|li| li.product.product_type_id}.include?( ProductType.digital_ecom.id )
  end

  def get_payment_methods
    adyen_client.checkout.payment_methods({
      merchantAccount: ENV["ADYEN_MERCHANT_ACCOUNT"],
      channel: "Web",
      shopperLocale: I18n.locale,
      amount: {
        currency: "USD",
        amount: self.total_cents
      }
    })
  end

  # Makes the /payments request
  # https://docs.adyen.com/api-explorer/#/PaymentSetupAndVerificationService/payments
  def make_payment(payment_method, browser_info, remote_ip, origin, return_url)
    response = adyen_client.checkout.payments({
      merchantAccount: ENV["ADYEN_MERCHANT_ACCOUNT"],
      channel: "Web",
      amount: {
        currency: "USD",
        value: self.total_cents,
      },
      reference: self.uuid,
      additionalData: {
        allow3DS2: true,
      },
      origin: origin,
      browserInfo: browser_info,
      shopperIP: remote_ip,
      returnUrl: return_url,
      paymentMethod: payment_method,
    })

    # store paymentData for redirect handling
    self.update(payment_data: response.response)

    if response.response.key?("action")
      # handle the action
    end

    response
  end

  # Makes the /payments/details request
  # https://docs.adyen.com/api-explorer/#/PaymentSetupAndVerificationService/payments/details
  def submit_details(details)
    adyen_client.checkout.payments.details(details)
  end

  private

  def adyen_client
    @adyen_client ||= instantiate_checkout_client
  end

  def instantiate_checkout_client
    adyen = Adyen::Client.new
    adyen.api_key = ENV["ADYEN_API_KEY"]
    adyen.env = ENV["ADYEN_ENV"].to_sym
    adyen
  end
end
