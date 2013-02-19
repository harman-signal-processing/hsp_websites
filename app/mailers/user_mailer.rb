class UserMailer < Devise::Mailer
	self.default :from => 'hsp_marketing@harman.com'
	default_url_options[:host] = "www.digitech.com"

  def confirmation_instructions(record, opts={})
  	determine_host(record)
  	if record.dealer?
  		if record.dealers && record.dealers.first && record.dealers.first.email.present?
	  		record.email = record.dealers.first.email
	  		super
  		else
  			cant_confirm(record, opts)
  		end
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
  	default_url_options[:host] = TOOLKIT_HOST
  	mail to: @email, 
  		cc: ["adam.anderson@harman.com"],
  		subject: "Can't confirm account", 
  		template_name: "cant_confirm"
  end

  private

  # Try to intelligently use a hostname that this user expects.
  # For example, toolkit users should go to the toolkit. Market
  # Managers should go to the brand they represent.
  #
  def determine_host(record)
  	begin
  		if record.dealer?
  			default_url_options[:host] = TOOLKIT_HOST
  		elsif record.brand_toolkit_contacts.count > 0
  			default_url_options[:host] = record.brand_toolkit_contacts.first.brand.default_website.url 
  		end
  	rescue
  		# something happened, use the default host
  	end
  end

end