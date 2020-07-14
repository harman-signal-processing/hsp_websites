class Admin::VipEmailsController < AdminController
  load_and_authorize_resource class: "Vip::Email"

  def index
    @vip_emails = Vip::Email.all.order(:email)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @vip_emails }
      format.json  { render json: @vip_emails }
    end    
  end

  def show
  end

  def new
  end

  def edit
  end
  
  def update
    @vip_email = Vip::Email.find(params[:id])
    respond_to do |format|
      if @vip_email.update(vip_email_params)
        format.html { redirect_to(admin_vip_emails_path, notice: 'AMX VIP Email was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip email: #{@vip_email.email}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_email.errors, status: :unprocessable_entity }
      end
    end 
  end  
  
  def create
    @vip_email = Vip::Email.new(vip_email_params)
    respond_to do |format|
      if @vip_email.save

        format.html { redirect_to(admin_vip_emails_path, notice: 'AMX VIP Email was successfully created.') }
        format.xml  { render xml: @vip_email, status: :created, location: @vip_email }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip email #{@vip_email.email}")
      else
        format.html { redirect_to(admin_vip_emails_path, notice: 'There was a problem creating the AMX VIP Email.') }
        format.xml  { render xml: @vip_email.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end      
  end    
  
  # DELETE /vip_emails/1
  # DELETE /vip_emails/1.xml
  def destroy
    @vip_email.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_emails_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted a amx vip email: #{@vip_email.email}")
  end   
  
  private
  
    def vip_email_params
  	  params.require(:vip_email).permit!
    end     

end
