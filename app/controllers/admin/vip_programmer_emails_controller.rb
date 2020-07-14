class Admin::VipProgrammerEmailsController < AdminController
	before_action :initialize_vip_programmer_email, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerEmail", except: [:update_order]
  skip_authorization_check only: [:update_order]
  
  
  # GET /admin/vip_programmer_emails
  # GET /admin/vip_programmer_emails.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @vip_programmer_email }
    end
  end

  # GET /admin/vip_programmer_emails/1
  # GET /admin/vip_programmer_emails/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @vip_programmer_email }
    end
  end   
  
  # GET /admin/vip_programmer_emails/new
  # GET /admin/vip_programmer_emails/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @vip_programmer_email }
    end
  end

  # GET /admin/vip_programmer_emails/1/edit
  def edit
  end  
  
  # POST /admin/vip_programmer_emails
  # POST /admin/vip_programmer_emails.xml
  def create
    @called_from = params[:called_from] || "vip_programmer"
    respond_to do |format|
      if @vip_programmer_emails.present?
        begin
          @vip_programmer_emails.each do |vip_programmer_email|
            begin
              vip_programmer_email.save!
              website.add_log(user: current_user, action: "Associated #{vip_programmer_email.programmer.name} with #{vip_programmer_email.email.email}")
              format.js
            rescue => e
              @error = "Error: #{e.message} : #{vip_programmer_email.email.email}"
              format.js { render template: "admin/vip_programmer_emails/create_error" }
            end
          end  #  @vip_programmer_emails.each do |vip_programmer_email|
          
        rescue => e
          @error = "Error: #{e.message}"
          format.js { render template: "admin/vip_programmer_emails/create_error" }
        end        
      else       
        if @vip_programmer_email.save
          format.html { redirect_to([:admin, @vip_programmer_email], notice: 'Programmer email was successfully created.') }
          format.xml  { render xml: @vip_programmer_email, status: :created, location: @vip_programmer_email }
          format.js 
          website.add_log(user: current_user, action: "Associated #{vip_programmer_email.programmer.name} with #{vip_programmer_email.email.email}")
        else
          format.html { render action: "new" }
          format.xml  { render xml: @vip_programmer_email.errors, status: :unprocessable_entity }
          format.js { render template: "admin/vip_programmer_emails/create_error" }
        end
      end
    end  #  respond_to do |format|
  end  #  def create    
  
  # PUT /admin/vip_programmer_emails/1
  # PUT /admin/vip_programmer_emails/1.xml
  def update
    respond_to do |format|
      if @vip_programmer_email.update(vip_programmer_email_params)
        format.html { redirect_to([:admin, @vip_programmer_email], notice: 'Programmer email was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer_email.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  def update_order
    update_list_order(Vip::ProgrammerEmail, params["vip_programmer_email"]) # update_list_order is in application_controller
    head :ok
    email.add_log(user: current_user, action: "Sorted VIP programmer emails")
  end   
  
  # DELETE /admin/vip_programmer_emails/1
  # DELETE /admin/vip_programmer_emails/1.xml
  def destroy
    @called_from = params[:called_from] || "vip_programmer"
    @vip_programmer_email.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_programmer_emails_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a email from #{@vip_programmer_email.programmer.name}")
  end  
  
  private

	  def initialize_vip_programmer_email
      if vip_programmer_email_params[:vip_email_id].is_a?(Array)
        @vip_programmer_emails = []
        vip_programmer_id = vip_programmer_email_params[:vip_programmer_id]
        vip_programmer_email_params[:vip_email_id].reject(&:blank?).each do |email|
          @vip_programmer_emails << Vip::ProgrammerEmail.new({vip_programmer_id: vip_programmer_id, vip_email_id: email})
        end        
      else
        @vip_programmer_email = Vip::ProgrammerEmail.new(vip_programmer_email_params)
      end	 	    
	  end  #  def initialize_vip_programmer_email
	
	  def vip_programmer_email_params
	    params.require(:vip_programmer_email).permit!
	  end  
end
