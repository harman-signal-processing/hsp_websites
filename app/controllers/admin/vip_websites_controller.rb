class Admin::VipWebsitesController < AdminController
  load_and_authorize_resource class: "Vip::Website"

  def index
    @vip_websites = Vip::Website.all.order(:url)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @vip_websites }
      format.json  { render json: @vip_websites }
    end    
  end

  def show
  end

  def new
  end

  def edit
  end
  
  def update
    @vip_website = Vip::Website.find(params[:id])
    respond_to do |format|
      if @vip_website.update(vip_website_params)
        format.html { redirect_to(admin_vip_websites_path, notice: 'AMX VIP Website was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip website: #{@vip_website.url}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_website.errors, status: :unprocessable_entity }
      end
    end 
  end  
  
  def create
    @vip_website = Vip::Website.new(vip_website_params)
    respond_to do |format|
      if @vip_website.save

        format.html { redirect_to(admin_vip_websites_path, notice: 'AMX VIP Website was successfully created.') }
        format.xml  { render xml: @vip_website, status: :created, location: @vip_website }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip website #{@vip_website.url}")
      else
        format.html { redirect_to(admin_vip_websites_path, notice: 'There was a problem creating the AMX VIP Website.') }
        format.xml  { render xml: @vip_website.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end      
  end    
  
  # DELETE /vip_websites/1
  # DELETE /vip_websites/1.xml
  def destroy
    @vip_website.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_websites_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted a amx vip website: #{@vip_website.url}")
  end   
  
  private
  
    def vip_website_params
  	  params.require(:vip_website).permit!
    end     

end
