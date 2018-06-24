class Admin::VipPhonesController < AdminController
  load_and_authorize_resource class: "Vip::Phone"

  def index
    @vip_phones = Vip::Phone.all.order(:phone)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @vip_phones }
      format.json  { render json: @vip_phones }
    end    
  end

  def show
  end

  def new
  end

  def edit
  end
  
  def update
    @vip_phone = Vip::Phone.find(params[:id])
    respond_to do |format|
      if @vip_phone.update_attributes(vip_phone_params)
        format.html { redirect_to(admin_vip_phones_path, notice: 'AMX VIP Phone was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip phone: #{@vip_phone.phone}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_phone.errors, status: :unprocessable_entity }
      end
    end 
  end  
  
  def create
    @vip_phone = Vip::Phone.new(vip_phone_params)
    respond_to do |format|
      if @vip_phone.save

        format.html { redirect_to(admin_vip_phones_path, notice: 'AMX VIP Phone was successfully created.') }
        format.xml  { render xml: @vip_phone, status: :created, location: @vip_phone }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip phone #{@vip_phone.phone}")
      else
        format.html { redirect_to(admin_vip_phones_path, notice: 'There was a problem creating the AMX VIP Phone.') }
        format.xml  { render xml: @vip_phone.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end      
  end    
  
  # DELETE /vip_phones/1
  # DELETE /vip_phones/1.xml
  def destroy
    @vip_phone.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_phones_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted a amx vip phone: #{@vip_phone.phone}")
  end   
  
  private
  
    def vip_phone_params
  	  params.require(:vip_phone).permit!
    end     

end
