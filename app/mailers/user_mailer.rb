class UserMailer < Devise::Mailer
	self.default :from => 'support@harmanpro.com'

  def confirmation_instructions(record, token, opts={})
    @token = token
  	if record.needs_account_number?
      initialize_from_record(record)
      to = [ @resource.email ]
  		if record.dealers && record.dealers.first && record.dealers.first.email.present?
        to << record.dealers.first.email
      elsif record.distributors && record.distributors.first && record.distributors.first.email.present?
        to << record.distributors.first.email
  		end
      mail to: to,
        subject: "Harman Websites Confirmation instructions",
        template_name: "dealer_confirmation_instructions"
  	elsif record.needs_invitation_code?
      devise_mail(record, :invited_confirmation_instructions, opts)
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

end
