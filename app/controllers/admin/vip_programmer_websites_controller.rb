class Admin::VipProgrammerWebsitesController < AdminController
	before_action :initialize_vip_programmer_website, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerWebsite", except: [:update_order]
  skip_authorization_check only: [:update_order]
  
  
  # GET /admin/vip_programmer_websites
  # GET /admin/vip_programmer_websites.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @vip_programmer_website }
    end
  end

  # GET /admin/vip_programmer_websites/1
  # GET /admin/vip_programmer_websites/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @vip_programmer_website }
    end
  end   
  
  # GET /admin/vip_programmer_websites/new
  # GET /admin/vip_programmer_websites/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @vip_programmer_website }
    end
  end

  # GET /admin/vip_programmer_websites/1/edit
  def edit
  end  
  
  # POST /admin/vip_programmer_websites
  # POST /admin/vip_programmer_websites.xml
  def create
    @called_from = params[:called_from] || "vip_programmer"
    respond_to do |format|
      if @vip_programmer_websites.present?
        begin
          @vip_programmer_websites.each do |vip_programmer_website|
            begin
              vip_programmer_website.save!
              website.add_log(user: current_user, action: "Associated #{vip_programmer_website.programmer.name} with #{vip_programmer_website.website.url}")
              format.js
            rescue => e
              @error = "Error: #{e.message} : #{vip_programmer_website.website.url}"
              format.js { render template: "admin/vip_programmer_websites/create_error" }
            end
          end  #  @vip_programmer_websites.each do |vip_programmer_website|
          
        rescue => e
          @error = "Error: #{e.message}"
          format.js { render template: "admin/vip_programmer_websites/create_error" }
        end        
      else       
        if @vip_programmer_website.save
          format.html { redirect_to([:admin, @vip_programmer_website], notice: 'Programmer website was successfully created.') }
          format.xml  { render xml: @vip_programmer_website, status: :created, location: @vip_programmer_website }
          format.js 
          website.add_log(user: current_user, action: "Associated #{vip_programmer_website.programmer.name} with #{vip_programmer_website.website.url}")
        else
          format.html { render action: "new" }
          format.xml  { render xml: @vip_programmer_website.errors, status: :unprocessable_entity }
          format.js { render template: "admin/vip_programmer_websites/create_error" }
        end
      end
    end  #  respond_to do |format|
  end  #  def create   
  
  # PUT /admin/vip_programmer_websites/1
  # PUT /admin/vip_programmer_websites/1.xml
  def update
    respond_to do |format|
      if @vip_programmer_website.update(vip_programmer_website_params)
        format.html { redirect_to([:admin, @vip_programmer_website], notice: 'Programmer website was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer_website.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  def update_order
    update_list_order(Vip::ProgrammerWebsite, params["vip_programmer_website"]) # update_list_order is in application_controller
    head :ok
    website.add_log(user: current_user, action: "Sorted VIP programmer websites")
  end   
  
  # DELETE /admin/vip_programmer_websites/1
  # DELETE /admin/vip_programmer_websites/1.xml
  def destroy
    @called_from = params[:called_from] || "vip_programmer"
    @vip_programmer_website.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_programmer_websites_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a website from #{@vip_programmer_website.programmer.name}")
  end  
  
  private

	  def initialize_vip_programmer_website
      if vip_programmer_website_params[:vip_website_id].is_a?(Array)
        @vip_programmer_websites = []
        vip_programmer_id = vip_programmer_website_params[:vip_programmer_id]
        vip_programmer_website_params[:vip_website_id].reject(&:blank?).each do |website|
          @vip_programmer_websites << Vip::ProgrammerWebsite.new({vip_programmer_id: vip_programmer_id, vip_website_id: website})
        end        
      else
        @vip_programmer_website = Vip::ProgrammerWebsite.new(vip_programmer_website_params)
      end	 	    
	  end  #  def initialize_vip_programmer_website
	
	  def vip_programmer_website_params
	    params.require(:vip_programmer_website).permit!
	  end  
end
