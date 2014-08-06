class Admin::BrandToolkitContactsController < AdminController
  before_filter :initialize_brand_toolkit_contact, only: :create
  load_and_authorize_resource except: [:load_user]
  skip_authorization_check :only => [:load_user]

  def index
  	redirect_to admin_toolkit_resources_path
  end

  def new
  	@brand_toolkit_contact.user = User.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
  end

  def load_user
  	@user = User.find(params[:id])
  	respond_to do |format|
		 format.js
		end
  end

  def create
  	@brand_toolkit_contact.brand_id = website.brand_id
    respond_to do |format|
      if @brand_toolkit_contact.save
        format.html { redirect_to(admin_brand_toolkit_contacts_url, notice: 'Contact was successfully created.') }
        website.add_log(user: current_user, action: "Created toolkit contact: #{@brand_toolkit_contact.user.name}")
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @brand_toolkit_contact.update_attributes(brand_toolkit_contact_params)
        format.html { redirect_to(admin_brand_toolkit_contacts_url, notice: 'Contact was successfully updated.') }
        website.add_log(user: current_user, action: "Updated toolkit contact: #{@brand_toolkit_contact.user.name}")
      else
        format.html { render action: "edit" }
      end
    end
  end

  def update_order
    update_list_order(BrandToolkitContact, params["brand_toolkit_contact"])
    render nothing: true
    website.add_log(user: current_user, action: "Sorted toolkit contacts")
  end

  def destroy
    @brand_toolkit_contact.destroy
    respond_to do |format|
      format.html { redirect_to(admin_brand_toolkit_contacts_url) }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted toolkit contact: #{@brand_toolkit_contact.user.name}")
  end

  private

  def initialize_brand_toolkit_contact
    @brand_toolkit_contact = BrandToolkitContact.new(brand_toolkit_contact_params)
  end

  def brand_toolkit_contact_params
    params.require(:brand_toolkit_contact).permit!
  end
end