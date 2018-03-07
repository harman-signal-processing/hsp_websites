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

  def news(news, recipient, from)
    @news = news

    # Attach the news photo if it exists.
    # Not anymore, now that images are on S3
    # if !@news.news_photo_file_name.blank?
    #   attachments.inline[@news.news_photo_file_name] = File.read(@news.news_photo.path(:email))
    # end

    # Determine if the brand has a custom template (default uses a HARMAN pro layout)
    website = @news.brand.default_website
    template_path = 'site_mailer'
    if File.exist?(Rails.root.join('app', 'views', website.folder, 'site_mailer', 'news.html.erb'))
      template_path = "#{website.folder}/site_mailer"
    end

    # Read the template and attach any needed images. Be sure the images exist in app/assets/images/news
    File.read(Rails.root.join('app', 'views', template_path, 'news.html.erb')).scan(/attachments\[\'([\w\.\-]*)\'\]/).each do |m|
      img = m.first
      attachments.inline[img] = File.read(Rails.root.join("app", "assets", "images", "news", img))
    end

    mail(to: recipient,
         from: from,
         subject: @news.title,
         template_path: template_path)
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

end
