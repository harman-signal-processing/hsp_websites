class ArtistRegistrationsController < Devise::RegistrationsController
  # include Devise::Controllers::InternalHelpers
  
  def new
    resource = build_resource({})
    resource.build_artist_products
    respond_with resource
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.initial_brand = website.brand
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      ArtistBrand.where(artist_id: resource.id, brand_id: website.brand_id).first_or_create
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_in(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        # Devise.mappings.each { |_,m| instance_variable_set("@current_#{m.name}", nil) }
        respond_with resource, location: become_an_artist_path
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

end
