class JitcRequestsController < ApplicationController
  before_action :set_locale

  def index
    process_request
  end

  def process_request
    if request.post?
      @contact_message = ContactMessage.new(contact_message_params) do |m|
        request_type = params[:contact_message][:security_request_type]
        other = params[:contact_message][:other]
        products = params[:contact_message][:products].reject(&:blank?)
        @products = products.join(', ')
        additional_content = params[:contact_message][:additional_info]
        @additional_info = additional_content
        @request_type = request_type
        @other = other
        message_content = request_type =="Other" ? "Request Type: #{request_type}, #{other}\r\n" : "Request Type: #{request_type}\r\n"
        message_content += "Products: #{products.join(', ')}\r\n"
        message_content += "Additional Information: #{additional_content}\r\n" if additional_content.present?
        m.message = message_content
        m.message_type = request_type
        m.brand = website.brand
        m.subject = "HARMAN Pro Security Request Form Submission"
        m.product = products.join(", ").length > 100 ? "Product list is in the message." : "#{products.join(', ')}"
      end
      if verify_recaptcha(model: @contact_message, secret_key: website.recaptcha_private_key) && @contact_message.valid?
      # if @contact_message.valid?
        @contact_message.save
        SiteMailer.delay.security_info_request(@contact_message, @products, @additional_info, @request_type, @other, website.brand.harman_pro_security_info_request_recipients)
        redirect_to support_path, notice: t('blurbs.contact_form_thankyou') and return false
      end
    else
      @contact_message = ContactMessage.new
    end
  end  #  process_request

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :company, :message, :message_type, security_request_type: [], other: [], product: [], additional_info: [])
  end
end  #  class JitcRequestsController < ApplicationController
