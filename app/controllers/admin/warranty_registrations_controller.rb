require 'csv'

class Admin::WarrantyRegistrationsController < AdminController
  load_and_authorize_resource except: :index
  # GET /admin/warranty_registrations
  # GET /admin/warranty_registrations.xml
  def index
    authorize! :read, WarrantyRegistration
    @warranty_registrations = WarrantyRegistration.where(brand_id: website.brand_id)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      # format.xls {
      #   send_data(@warranty_registrations.to_xls(
      #     headers: ["title", "first name", "last name", "middle", "company", "job title", 
      #               "address", "city", "state", "zip",  "country", "phone", "fax", "email",
      #               "subscribe", "brand", "product", "serial number", "registered date",
      #               "purchase date", "purchased from", "purchase country", "purchase price",
      #               "age", "question 1", "question 2", "question 3", "question 4", "question 5",
      #               "question 6", "question 7", "comments"],
      #     columns: [:title, :first_name, :last_name, :middle_initial, :company, :jobtitle,
      #               :address1, :city, :state, :zip, :country, :phone, :fax, :email, 
      #               :subscribe, :brand_name, :product_name, :serial_number, :registered_on,
      #               :purchased_on, :purchased_from, :purchase_country, :purchase_price, 
      #               :age, :marketing_question1, :marketing_question2, :marketing_question3,
      #               :marketing_question4, :marketing_question5, :marketing_question6,
      #               :marketing_question7, :comments]
      #     )          
      #   )
      # }
      # format.csv {
      #   send_data(CSV.generate do |csv|
      #     @warranty_registrations.each do |item|
      #       csv << [item.title, item.first_name, item.last_name, item.middle_initial, item.company, item.jobtitle,
      #               item.address1, item.city, item.state, item.zip, item.country, item.phone, item.fax, item.email, 
      #               item.subscribe, item.brand_name, item.product_name, item.serial_number, item.registered_on,
      #               item.purchased_on, item.purchased_from, item.purchase_country, item.purchase_price, 
      #               item.age, item.marketing_question1, item.marketing_question2, item.marketing_question3,
      #               item.marketing_question4, item.marketing_question5, item.marketing_question6,
      #               item.marketing_question7, item.comments]
      #     end
      #   end)
      # }
      format.csv {
        send_file(Rails.root.join("..", "..", "all_registrations.txt"), type: 'text/csv')
      }
      format.xml  { 
        render xml: @warranty_registrations 
      }
    end
  end
  
  # PUT /admin/warranty_registrations/search
  def search
    @warranty_registrations = WarrantyRegistrations.search(params[:search_string])
    respond_to do |format|
      format.html
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
      if @warranty_registration.update_attributes(params[:warranty_registration])
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
end
