class Toolkit::Users::RegistrationsController < Devise::RegistrationsController
	layout 'toolkit'

  def select_signup_type
  end

  def new
    resource = build_resource({})
    @signup_type = params[:signup_type] || "dealer"
    eval("resource.#{@signup_type} = true")
    respond_with resource
  end

  # POST /resource
  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      @signup_type = params[:signup_type] || "dealer"
      clean_up_passwords resource
      respond_with resource
    end
  end

end