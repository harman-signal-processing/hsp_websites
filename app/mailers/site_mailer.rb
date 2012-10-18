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
    brand = @order.label_sheets.first.products.first.brand
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
end
