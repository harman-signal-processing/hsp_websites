class Admin::VipProgrammerEmailsController < AdminController
	before_action :initialize_vip_programmer_email, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerEmail"	
  
  
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
      if @vip_programmer_email.save
        format.html { redirect_to([:admin, @vip_programmer_email], notice: 'Programmer email was successfully created.') }
        format.xml  { render xml: @vip_programmer_email, status: :created, location: @vip_programmer_email }
        format.js 
        website.add_log(user: current_user, action: "Associated a email with #{@vip_programmer_email.programmer.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @vip_programmer_email.errors, status: :unprocessable_entity }
        format.js { render template: "admin/vip_programmer_emails/create_error" }
      end
    end
  end  
  
  # PUT /admin/vip_programmer_emails/1
  # PUT /admin/vip_programmer_emails/1.xml
  def update
    respond_to do |format|
      if @vip_programmer_email.update_attributes(vip_programmer_email_params)
        format.html { redirect_to([:admin, @vip_programmer_email], notice: 'Programmer email was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer_email.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  # DELETE /admin/vip_programmer_emails/1
  # DELETE /admin/vip_programmer_emails/1.xml
  def destroy
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
	    @vip_programmer_email = Vip::ProgrammerEmail.new(vip_programmer_email_params)
	  end
	
	  def vip_programmer_email_params
	    params.require(:vip_programmer_email).permit!
	  end  
end
