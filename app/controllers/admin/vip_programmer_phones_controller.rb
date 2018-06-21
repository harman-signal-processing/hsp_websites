class Admin::VipProgrammerPhonesController < AdminController
	before_action :initialize_vip_programmer_phone, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerPhone"	
  
  
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
      if @vip_programmer_phone.save
        format.html { redirect_to([:admin, @vip_programmer_phone], notice: 'Programmer phone was successfully created.') }
        format.xml  { render xml: @vip_programmer_phone, status: :created, location: @vip_programmer_phone }
        format.js 
        website.add_log(user: current_user, action: "Associated a phone with #{@vip_programmer_phone.programmer.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @vip_programmer_phone.errors, status: :unprocessable_entity }
        format.js { render template: "admin/vip_programmer_phones/create_error" }
      end
    end
  end  
  
  # PUT /admin/vip_programmer_phones/1
  # PUT /admin/vip_programmer_phones/1.xml
  def update
    respond_to do |format|
      if @vip_programmer_phone.update_attributes(vip_programmer_phone_params)
        format.html { redirect_to([:admin, @vip_programmer_phone], notice: 'Programmer phone was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer_phone.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  # DELETE /admin/vip_programmer_phones/1
  # DELETE /admin/vip_programmer_phones/1.xml
  def destroy
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
	    @vip_programmer_phone = Vip::ProgrammerPhone.new(vip_programmer_phone_params)
	  end
	
	  def vip_programmer_phone_params
	    params.require(:vip_programmer_phone).permit!
	  end  
end
