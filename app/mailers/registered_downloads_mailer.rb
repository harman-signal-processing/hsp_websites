class RegisteredDownloadsMailer < ActionMailer::Base

  # The custom path we used to use doesn't work anymore,
  # So, the email templates are now in the repo, in the
  # app/views/registered_downloads_mailer folder :(
  # https://github.com/rails/rails/issues/22045
  def download_link(download_registration)
    @download_registration = download_registration
    mail(to: @download_registration.email,
      subject: @download_registration.registered_download.subject,
      from: "#{@download_registration.registered_download.brand.name} <#{@download_registration.registered_download.from_email}>") do |format|
        format.html { render @download_registration.registered_download.email_template_name.to_s }
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
