class Admin::SignupsController < AdminController
  before_action :initialize_signup, only: :create
  load_and_authorize_resource except: :show_campaign
  skip_authorization_check only: :show_campaign

  # GET /signups
  # GET /signups.xml
  def index
    @signups = @signups.where(brand_id: website.brand_id)
    if @signups.where("campaign IS NOT NULL").pluck(:campaign).uniq.length > 1
      @signups = @signups.group(:campaign)
      respond_to do |format|
        format.html { render_template } # index.html.erb
        format.xml  { render xml: @signups }
      end
    else
      render_signups
    end
  end

  def show_campaign
    @signups = Signup.where(brand_id: website.brand_id, campaign: params[:id])
    render_signups
  end

  # GET /signups/1
  # GET /signups/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @signup }
    end
  end

  # GET /signups/new
  # GET /signups/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @signup }
    end
  end

  # GET /signups/1/edit
  def edit
  end

  # POST /signups
  # POST /signups.xml
  def create
    respond_to do |format|
      if @signup.save
        format.html { redirect_to([:admin, @signup], notice: 'Signup was successfully created.') }
        format.xml  { render xml: @signup, status: :created, location: @signup }
        website.add_log(user: current_user, action: "Created signup: #{@signup.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @signup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /signups/1
  # PUT /signups/1.xml
  def update
    respond_to do |format|
      if @signup.update_attributes(signup_params)
        format.html { redirect_to([:admin, @signup], notice: 'Signup was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated signup: #{@signup.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @signup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /signups/1
  # DELETE /signups/1.xml
  def destroy
    @signup.destroy
    respond_to do |format|
      format.html { redirect_to(admin_signups_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted amp model: #{@signup.name}")
  end

  private

  def initialize_signup
    @signup = Signup.new(signup_params)
  end

  def signup_params
    params.require(:signup).permit!
  end

  def render_signups
    respond_to do |format|
      format.html { render plain: @signups.to_yaml }
      format.text { render plain: @signups.to_yaml }
      format.xls {
        if params[:id]
          fn = "#{website.brand.name}_#{params[:id].gsub(/\s/,"-")}_signups.xls"
        else
          fn = "#{website.brand.name}_signups.xls"
        end
        send_data(@signups.to_a.to_xls(
          headers: ["First Name", "Last Name", "Company", "Email", "Address", "City", "State", "Zip Code", "Date"],
          columns: [:first_name, :last_name, :company, :email, :address, :city, :state, :zip, :created_at]),
        filename: fn)
      }
    end
  end
end
