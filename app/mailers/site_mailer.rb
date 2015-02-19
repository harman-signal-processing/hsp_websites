class SiteMailer < ActionMailer::Base

  def contact_form(contact_message, website)
    @brand = website.brand
    @contact_message = contact_message
    @recipient = website.brand.support_email
    if subj = SupportSubject.where(brand_id: website.brand_id, name: @contact_message.subject).first
      @recipient = subj.recipient if subj.recipient.present?
    elsif @contact_message.catalog_request?
      @recipient = "service@sullivangroup.com"
    elsif @contact_message.part_request?
      if p = website.brand.parts_email
        if p.to_s.match(/\@/)
          @recipient = p
        end
      end
    end
    mail(to: @recipient,
      subject: @contact_message.subject,
      from: @contact_message.email)
  end

  def promo_post_registration(warranty_registration, promotion)
    @warranty_registration = warranty_registration
    @brand = @warranty_registration.brand
    @promotion = promotion
    mail(to: @warranty_registration.email,
      from: @brand.support_email,
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
    brand = @order.expanded_label_sheets.first.products.first.brand
    @website = brand.default_website
    mail(to: @website.epedal_label_order_recipient,
      from: @order.email,
      subject: "epedal label sheet order")
  end

  def label_sheet_order_shipped(order)
    @order = order
    mail(to: @order.email,
      from: "support@digitech.com",
      subject: "Your epedal labels are on their way!")
  end

  def confirm_product_registration(warranty_registration)
    @warranty_registration = warranty_registration
    @brand = @warranty_registration.brand
    mail(to: @warranty_registration.email,
      from: @brand.support_email,
      subject: "#{@brand.name} product registration")
  end
end
