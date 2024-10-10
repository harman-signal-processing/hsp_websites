class SiteMailer < ApplicationMailer

  def contact_form(contact_message, options={})
    @contact_message = contact_message

    mail(to: @contact_message.recipients,
         reply_to: @contact_message.email,
         subject: @contact_message.subject)
  end

  def promo_post_registration(warranty_registration, promotion)
    @warranty_registration = warranty_registration
    @brand = @warranty_registration.brand
    @promotion = promotion
    mail(to: @warranty_registration.email,
         from: "#{@brand.name} <#{ENV['DEFAULT_SENDER']}>",
         subject: @promotion.post_registration_subject)
  end

  # Sends messages to AR when an artist changed info
  # bcc to adam is temporary.
  def artist_approval(artist, recipients)
    @artist = artist
    mail(to: recipients,
         subject: "Artist relations approval")
  end

  def confirm_product_registration(warranty_registration)
    @warranty_registration = warranty_registration
    @brand = @warranty_registration.brand
    mail(to: @warranty_registration.email,
         from: "#{@brand.name} <#{ENV['DEFAULT_SENDER']}>",
         bcc: @brand.bcc_product_registrations.present? ? @brand.bcc_product_registrations.split(/[\s\,\;]{1,}/) : [],
         subject: "#{@brand.name} product registration")
  end

  def training_class_registration_notice(training_class_registration)
    @training_class_registration = training_class_registration

    mail(to: @training_class_registration.registration_recipients,
         subject: @training_class_registration.training_class.name)
  end

  def fixtures_request(data)
    @fixtures_request = data
    if @fixtures_request.attachment.present?
      begin
        attachments[@fixtures_request.attachment_file_name] = {
          mime_type: @fixtures_request.attachment_content_type,
          content: URI.open(@fixtures_request.attachment.url).read
        }
      rescue
        # couldn't attach the file, but we'll link to it anyway
      end
    end
    mail(to: ENV['MARTIN_FIXTURES_RECIPIENT'],
         subject: "Martin Fixtures Request")
  end

  def amx_itg_module_request(data, recipients)
    @module_request = data
    if @module_request.attachment.present?
      begin
        attachments[@module_request.attachment_file_name] = {
          mime_type: @module_request.attachment_content_type,
          content: URI.open(@module_request.attachment.url.gsub("_original.",".")).read
        }
      rescue
        # couldn't attach the file, but we'll link to it anyway
      end
    end  #  if @module_request.attachment.present?

    mail(to: recipients.split(";"),
         from: @module_request.email,
         subject: "AMX ITG New Module Request")
  end  #  def amx_itg_module_request(data)

  def amx_partner_interest_form(data, recipients)
    @partner_interest_request = data
    mail(to: recipients.split(";"),
         from: @partner_interest_request.email,
         subject: "AMX Partner Interest Form")
  end  #  def amx_partner_interest_form(data, recipients)

  def security_info_request(contact_message, products, additional_info, request_type, other, recipients)
    @contact_message = contact_message
    @products = products
    @additional_info = additional_info
    @request_type = request_type
    @other = other
    mail(to: recipients.split(";"), subject: @contact_message.subject)
  end

  def jbl_vertec_vtx_owner_form(data, recipients)
    @jbl_vertec_vtx_owner = data
    mail(to: recipients.split(";"),
         from: @jbl_vertec_vtx_owner.email,
         subject: "JBL Vertec/VTX Owner Form")
  end

  def monthly_software_report
    @software_report = params[:software_report]
    mail(to: @software_report.recipients,
         subject: "#{@software_report.software.name} Monthly Report")
  end
end  #  class SiteMailer < ActionMailer::Base
