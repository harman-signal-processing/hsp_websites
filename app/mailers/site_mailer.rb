class SiteMailer < ActionMailer::Base

  def contact_form(contact_message, brand)
    @brand = brand
    @contact_message = contact_message
    mail(to: @brand.support_email, 
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
    if !@news.news_photo_file_name.blank?
      attachments.inline[@news.news_photo_file_name] = File.read(@news.news_photo.path(:email))
    end
    attachments.inline['AKG.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'AKG.png'))
    attachments.inline['BSS.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'BSS.png'))
    attachments.inline['Crown.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'Crown.png'))
    attachments.inline['DBX.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'DBX.png'))
    attachments.inline['footer_fb.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'footer_fb.png'))
    attachments.inline['footer_rss.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'footer_rss.png'))
    attachments.inline['footer_twitter.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'footer_twitter.png'))
    attachments.inline['footer_ytube.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'footer_ytube.png'))
    attachments.inline['harman.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'harman.png'))
    attachments.inline['HiQnet.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'HiQnet.png'))
    attachments.inline['JBL.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'JBL.png'))
    attachments.inline['Lexicon.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'Lexicon.png'))
    attachments.inline['Martin.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'Martin.png'))
    attachments.inline['Soundcraft.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'Soundcraft.png'))
    attachments.inline['Studer.png'] = File.read(Rails.root.join("app", "assets", "images", "news", 'Studer.png'))

    mail(to: recipient, from: from, subject: @news.title)
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
