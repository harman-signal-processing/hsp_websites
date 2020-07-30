class Admin::ManufacturerPartnersController < AdminController
  before_action :initialize_manufacturer_partner, only: :create
  load_and_authorize_resource
    
  # GET /manufacturer_partners
  # GET /manufacturer_partners.xml
  # GET /manufacturer_partners.json
  def index
    @manufacturer_partners = ManufacturerPartner.all.order(:name)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @manufacturer_partners }
      format.json  { render json: @manufacturer_partners }
    end
  end
  
  # GET /manufacturer_partners/1
  # GET /manufacturer_partners/1.xml
  # GET /manufacturer_partners/1.json
  def show
    @manufacturer_partner = ManufacturerPartner.find(params[:id])
    @logos = SiteElement.where("name LIKE '%logo_inconcert_%'").order(:name)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @manufacturer_partner }
      format.json  { render json: @manufacturer_partner }
    end
  end
  
  def new
    @manufacturer_partner = ManufacturerPartner.new()
    @logos = SiteElement.where("name LIKE '%logo_inconcert_%'").order(:name)
  end
  
  def create
    # @manufacturer_partner = ManufacturerPartner.new(manufacturer_partner_params)
    respond_to do |format|
      if @manufacturer_partner.save
        format.html { redirect_to([:admin, @manufacturer_partner], notice: 'Manufacturer Partner was successfully created.') }
        format.xml  { render xml: @manufacturer_partner, status: :created, location: @manufacturer_partner }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created manufacturer partner #{@manufacturer_partner.name}")
      else
        format.html { redirect_to([:admin, @manufacturer_partner], notice: 'There was a problem creating the Manufacturer Partner.') }
        format.xml  { render xml: @manufacturer_partner.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end    
    
  end
  
  
  # PUT /manufacturer_partners/1
  # PUT /manufacturer_partners/1.xml
  def update
    @manufacturer_partner = ManufacturerPartner.find(params[:id])
    respond_to do |format|
      if @manufacturer_partner.update(manufacturer_partner_params)
        format.html { redirect_to([:admin, @manufacturer_partner], notice: 'Manufacturer Partner was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a manufacturer partner: #{@manufacturer_partner.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @manufacturer_partner.errors, status: :unprocessable_entity }
      end
    end
  end
    
    
  # DELETE /manufacturer_partners/1
  # DELETE /manufacturer_partners/1.xml
  def destroy
    @manufacturer_partner.destroy
    respond_to do |format|
      format.html { redirect_to(admin_manufacturer_partners_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted a manufacturer partner: #{@manufacturer_partner.name}")
  end    
    
    
  private
  
    def initialize_manufacturer_partner
    @manufacturer_partner = ManufacturerPartner.new(manufacturer_partner_params)
    end
  
    def manufacturer_partner_params
  	  params.require(:manufacturer_partner).permit!
    end
    
end
