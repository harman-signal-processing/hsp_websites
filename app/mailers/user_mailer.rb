class UserMailer < Devise::Mailer
	self.default :from => 'hsp_marketing@harman.com'
  default_url_options[:host] = HarmanSignalProcessingWebsite::Application.config.toolkit_url

  def confirmation_instructions(record, token, opts={})
    @token = token
  	if record.needs_account_number?
  		if record.dealers && record.dealers.first && record.dealers.first.email.present?
        initialize_from_record(record)
	  		mail to: record.dealers.first.email,
          subject: "Harman Toolkit Confirmation instructions",
          template_name: "dealer_confirmation_instructions"
      elsif record.distributors && record.distributors.first && record.distributors.first.email.present?
        initialize_from_record(record)
        mail to: record.distributors.first.email,
          subject: "Harman Toolkit Confirmation instructions",
          template_name: "dealer_confirmation_instructions"
  		else
  			cant_confirm(record, opts)
  		end
  	elsif record.needs_invitation_code?
      devise_mail(record, :toolkit_confirmation_instructions, opts)
    else
  		super
  	end
  end

  def reset_password_instructions(record, token, opts={})
    super
  end

  def unlock_instructions(record, token, opts={})
    super
  end

  def cant_confirm(record, opts={})
  	initialize_from_record(record)
  	@email = @resource.email
  	mail to: @email,
  		cc: HarmanSignalProcessingWebsite::Application.config.toolkit_admin_email_addresses,
  		subject: "Harman Toolkit can't confirm account",
  		template_name: "cant_confirm"
  end

end
