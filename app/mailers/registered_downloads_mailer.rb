class RegisteredDownloadsMailer < ActionMailer::Base

  def download_link(download_registration)
    @download_registration = download_registration
    mail(to: @download_registration.email, 
      subject: @download_registration.registered_download.subject, 
      from: @download_registration.registered_download.from_email) do |format|
        format.html { render @download_registration.registered_download.email_layout_filename.to_s }
      end
  end
  
  def admin_notice(download_registration)
    @download_registration = download_registration
    @registered_download = download_registration.registered_download
    @brand = @registered_download.brand
    mail(to: @registered_download.cc,
      subject: "#{@registered_download.name}: new registration",
      from: @brand.support_email)
  end
  
end
