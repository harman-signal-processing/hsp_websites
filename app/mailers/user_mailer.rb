class UserMailer < Devise::Mailer
	self.default :from => 'hsp_marketing@harman.com'
	default_url_options[:host] = "www.digitech.com"

  def confirmation_instructions(record, opts={})
  	determine_host(record)
  	if record.needs_account_number?
  		if record.dealers && record.dealers.first && record.dealers.first.email.present?
        initialize_from_record(record)
	  		mail to: record.dealers.first.email,
          subject: "Harman Toolkit Confirmation instructions",
          template_name: "dealer_confirmation_instructions"
  		else
  			cant_confirm(record, opts)
  		end
  	elsif record.needs_invitation_code?
      devise_mail(record, :rso_confirmation_instructions, opts)
    else
  		super
  	end
  end

  def reset_password_instructions(record, opts={})
  	determine_host(record)
    super
  end

  def unlock_instructions(record, opts={})
  	determine_host(record)
    super
  end

  def cant_confirm(record, opts={})
  	initialize_from_record(record)
  	@email = @resource.email
  	default_url_options[:host] = HarmanSignalProcessingWebsite::Application.config.toolkit_url
  	mail to: @email, 
  		cc: HarmanSignalProcessingWebsite::Application.config.toolkit_admin_email_addresses,
  		subject: "Harman Toolkit can't confirm account", 
  		template_name: "cant_confirm"
  end

  private

  # Try to intelligently use a hostname that this user expects.
  # For example, toolkit users should go to the toolkit. Market
  # Managers should go to the brand they represent.
  #
  def determine_host(record)
  	begin
  		if record.needs_account_number? || record.needs_invitation_code?
  			default_url_options[:host] = HarmanSignalProcessingWebsite::Application.config.toolkit_url
  		elsif record.brand_toolkit_contacts.count > 0
  			default_url_options[:host] = record.brand_toolkit_contacts.first.brand.default_website.url
      end
      if record.role?(:admin) || record.role?(:customer_service) || record.role?(:translator) ||
        record.role?(:market_manager) || record.role?(:artist_relations) || record.role?(:rohs) ||
        record.role?(:clinician) || record.role?(:clinician_admin) || record.role?(:marketing_staff) ||
        record.role?(:sales_admin) 
        default_url_options[:host] += "/en-US/admin"
  		end
  	rescue
  		# something happened, use the default host
  	end
  end

end