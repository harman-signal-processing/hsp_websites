class ArtistRegistrationsController < Devise::RegistrationsController
  # include Devise::Controllers::InternalHelpers
  
  def new
    resource = build_resource({})
    resource.build_artist_products
    respond_with resource
  end

  # POST /resource
  def create
    build_resource

    resource.initial_brand = website.brand
    if resource.save
      ArtistBrand.find_or_create_by_artist_id_and_brand_id(resource.id, website.brand_id)
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        # Devise.mappings.each { |_,m| instance_variable_set("@current_#{m.name}", nil) }
        respond_with resource, location: become_an_artist_path
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

end
