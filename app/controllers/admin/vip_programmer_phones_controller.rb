class Admin::VipProgrammerPhonesController < AdminController
	before_action :initialize_vip_programmer_phone, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerPhone", except: [:update_order]
  skip_authorization_check only: [:update_order]
  
  
  # GET /admin/vip_programmer_phones
  # GET /admin/vip_programmer_phones.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @vip_programmer_phone }
    end
  end

  # GET /admin/vip_programmer_phones/1
  # GET /admin/vip_programmer_phones/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @vip_programmer_phone }
    end
  end   
  
  # GET /admin/vip_programmer_phones/new
  # GET /admin/vip_programmer_phones/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @vip_programmer_phone }
    end
  end

  # GET /admin/vip_programmer_phones/1/edit
  def edit
  end  
  
  # POST /admin/vip_programmer_phones
  # POST /admin/vip_programmer_phones.xml
  def create
    @called_from = params[:called_from] || "vip_programmer"
    respond_to do |format|
      if @vip_programmer_phones.present?
        begin
          @vip_programmer_phones.each do |vip_programmer_phone|
            begin
              vip_programmer_phone.save!
              website.add_log(user: current_user, action: "Associated #{vip_programmer_phone.programmer.name} with #{vip_programmer_phone.phone.phone}")
              format.js
            rescue => e
              @error = "Error: #{e.message} : #{vip_programmer_phone.phone.phone}"
              format.js { render template: "admin/vip_programmer_phones/create_error" }
            end
          end  #  @vip_programmer_phones.each do |vip_programmer_phone|
          
        rescue => e
          @error = "Error: #{e.message}"
          format.js { render template: "admin/vip_programmer_phones/create_error" }
        end        
      else       
        if @vip_programmer_phone.save
          format.html { redirect_to([:admin, @vip_programmer_phone], notice: 'Programmer phone was successfully created.') }
          format.xml  { render xml: @vip_programmer_phone, status: :created, location: @vip_programmer_phone }
          format.js 
          website.add_log(user: current_user, action: "Associated #{vip_programmer_phone.programmer.name} with #{vip_programmer_phone.phone.phone}")
        else
          format.html { render action: "new" }
          format.xml  { render xml: @vip_programmer_phone.errors, status: :unprocessable_entity }
          format.js { render template: "admin/vip_programmer_phones/create_error" }
        end
      end
    end  #  respond_to do |format|
  end  #  def create 
  
  # PUT /admin/vip_programmer_phones/1
  # PUT /admin/vip_programmer_phones/1.xml
  def update
    respond_to do |format|
      if @vip_programmer_phone.update(vip_programmer_phone_params)
        format.html { redirect_to([:admin, @vip_programmer_phone], notice: 'Programmer phone was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer_phone.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  def update_order
    update_list_order(Vip::ProgrammerPhone, params["vip_programmer_phone"]) # update_list_order is in application_controller
    head :ok
    website.add_log(user: current_user, action: "Sorted VIP programmer phones")
  end    
  
  # DELETE /admin/vip_programmer_phones/1
  # DELETE /admin/vip_programmer_phones/1.xml
  def destroy
    @called_from = params[:called_from] || "vip_programmer"
    @vip_programmer_phone.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_programmer_phones_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a phone from #{@vip_programmer_phone.programmer.name}")
  end  
  
  private

	  def initialize_vip_programmer_phone
      if vip_programmer_phone_params[:vip_phone_id].is_a?(Array)
        @vip_programmer_phones = []
        vip_programmer_id = vip_programmer_phone_params[:vip_programmer_id]
        vip_programmer_phone_params[:vip_phone_id].reject(&:blank?).each do |phone|
          @vip_programmer_phones << Vip::ProgrammerPhone.new({vip_programmer_id: vip_programmer_id, vip_phone_id: phone})
        end        
      else
        @vip_programmer_phone = Vip::ProgrammerPhone.new(vip_programmer_phone_params)
      end	 	    
	  end  #  def initialize_vip_programmer_phone
	
	  def vip_programmer_phone_params
	    params.require(:vip_programmer_phone).permit!
	  end  
end
