require 'csv'

class Admin::WarrantyRegistrationsController < AdminController
  before_action :initialize_warranty_registration, only: :create
  load_and_authorize_resource except: :index

  # GET /admin/warranty_registrations
  # GET /admin/warranty_registrations.xml
  def index
    authorize! :read, WarrantyRegistration
    @brand_registrations = WarrantyRegistration.where(brand_id: website.brand_id)
    @search = @brand_registrations.ransack(params[:q])
    if params[:q]
      @warranty_registrations = @search.result(:distinct => true).eager_load(:product)
    else
      @warranty_registrations = []
    end
    respond_to do |format|
      format.html { render_template }
      format.xls {
        if @warranty_registrations == []
          @warranty_registrations = @brand_registrations
        end
        send_data(@warranty_registrations.to_a.to_xls(
          headers: ["title", "first name", "last name", "middle", "company", "job title",
                    "country", "email",
                    "subscribe", "brand", "product", "serial number", "registered date",
                    "purchase date", "purchased from", "purchase country", "purchase price"],
          columns: [:title, :first_name, :last_name, :middle_initial, :company, :jobtitle,
                    :country, :email,
                    :subscribe, :brand_name, :product_name, :serial_number, :registered_on,
                    :purchased_on, :purchased_from, :purchase_country, :purchase_price,
                    :comments]
          ),
          filename: "#{website.brand.name}_product_registrations_#{I18n.l Date.today}.xls",
          type: "application/excel; charset=utf-8; header=present"
        )
      }
      #format.csv {
      #  send_file(Rails.root.join("..", "..", "all_registrations.txt"), type: 'text/csv', filename: "all_registrations.csv")
      #}
      format.xml  {
        render xml: @brand_registrations
      }
    end
  end

  # GET /admin/warranty_registrations/1
  # GET /admin/warranty_registrations/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @warranty_registration }
    end
  end

  # GET /admin/warranty_registrations/new
  # GET /admin/warranty_registrations/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @warranty_registration }
    end
  end

  # GET /admin/warranty_registrations/1/edit
  def edit
  end

  # POST /admin/warranty_registrations
  # POST /admin/warranty_registrations.xml
  def create
    respond_to do |format|
      if @warranty_registration.save
        format.html { redirect_to([:admin, @warranty_registration], notice: 'Warranty registration was successfully created.') }
        format.xml  { render xml: @warranty_registration, status: :created, location: @warranty_registration }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @warranty_registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/warranty_registrations/1
  # PUT /admin/warranty_registrations/1.xml
  def update
    respond_to do |format|
      if @warranty_registration.update_attributes(warranty_registration_params)
        format.html { redirect_to([:admin, @warranty_registration], notice: 'Warranty registration was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @warranty_registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/warranty_registrations/1
  # DELETE /admin/warranty_registrations/1.xml
  def destroy
    @warranty_registration.destroy
    respond_to do |format|
      format.html { redirect_to(admin_warranty_registrations_url) }
      format.xml  { head :ok }
    end
  end

  private

  def initialize_warranty_registration
    @warranty_registration = WarrantyRegistration.new(warranty_registration_params)
  end

  def warranty_registration_params
    params.require(:warranty_registration).permit!
  end
end
