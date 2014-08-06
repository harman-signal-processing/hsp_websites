class Toolkit::Users::RegistrationsController < Devise::RegistrationsController
	layout 'toolkit'

  def select_signup_type
  end

  def new
    resource = build_resource({})
    @signup_type = params[:signup_type] || "dealer"
    eval("resource.#{@signup_type} = true")
    respond_with self.resource
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, :location => new_user_session_path
      end
    else
      @signup_type = params[:signup_type] || "dealer"
      clean_up_passwords resource
      respond_with resource
    end
  end

end