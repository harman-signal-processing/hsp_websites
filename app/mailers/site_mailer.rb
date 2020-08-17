class SiteMailer < ActionMailer::Base

  def contact_form(contact_message, options={})
    @contact_message = contact_message

    mail(to: @contact_message.recipients,
         subject: @contact_message.subject,
         from: @contact_message.email)
  end

  def promo_post_registration(warranty_registration, promotion)
    @warranty_registration = warranty_registration
    @brand = @warranty_registration.brand
    @promotion = promotion
    mail(to: @warranty_registration.email,
         from: "#{@brand.name} <#{@brand.support_email}>",
         subject: @promotion.post_registration_subject)
  end

  # Sends messages to AR when an artist changed info
  # bcc to adam is temporary.
  def artist_approval(artist, recipients)
    @artist = artist
    mail(to: recipients,
         bcc: "adam.anderson@harman.com",
         from: "support@digitech.com",
         subject: "Artist relations approval")
  end

  def label_sheet_order(order)
    @order = order
    brand = @order.expanded_label_sheets.first.decoded_products.first.brand
    @website = brand.default_website
    mail(to: @website.epedal_label_order_recipient,
         from: @order.email,
         subject: "epedal label sheet order")
  end

  def label_sheet_order_shipped(order)
    @order = order
    mail(to: @order.email,
         from: "DigiTech <support@digitech.com>",
         subject: "Your epedal labels are on their way!")
  end

  def confirm_product_registration(warranty_registration)
    @warranty_registration = warranty_registration
    @brand = @warranty_registration.brand
    mail(to: @warranty_registration.email,
         from: "#{@brand.name} <#{@brand.support_email}>",
         bcc: @brand.respond_to?(:bcc_product_registrations) ? @brand.bcc_product_registrations.split(/[\s\,\;]{1,}/) : [],
         subject: "#{@brand.name} product registration")
  end

  def new_system_configuration(system_configuration)
    @system_configuration = system_configuration

    mail(to: @system_configuration.recipients,
         from: @system_configuration.from,
         subject: "New System Configuration Submitted")
  end

  def training_class_registration_notice(training_class_registration)
    @training_class_registration = training_class_registration

    mail(to: @training_class_registration.registration_recipients,
         from: @training_class_registration.email,
         subject: @training_class_registration.training_class.name)
  end

  def fixtures_request(data)
    @fixtures_request = data
    if @fixtures_request.attachment.present?
      begin
        attachments[@fixtures_request.attachment_file_name] = {
          mime_type: @fixtures_request.attachment_content_type,
          content: open(@fixtures_request.attachment.url).read
        }
      rescue
        # couldn't attach the file, but we'll link to it anyway
      end
    end
    mail(to: ENV['MARTIN_FIXTURES_RECIPIENT'],
         from: @fixtures_request.email,
         subject: "Martin Fixtures Request")
  end

  def amx_itg_module_request(data, recipients)
    @module_request = data
    if @module_request.attachment.present?
      begin
        attachments[@module_request.attachment_file_name] = {
          mime_type: @module_request.attachment_content_type,
          content: open(@module_request.attachment.url.gsub("_original.",".")).read
        }
      rescue
        # couldn't attach the file, but we'll link to it anyway
      end
    end  #  if @module_request.attachment.present?

    mail(to: recipients.split(";"),
         from: @module_request.email,
         subject: "AMX ITG New Module Request")
  end  #  def amx_itg_module_request(data)

end  #  class SiteMailer < ActionMailer::Base
