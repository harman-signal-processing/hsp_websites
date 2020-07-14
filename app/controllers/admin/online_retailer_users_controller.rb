class Admin::OnlineRetailerUsersController < AdminController
  before_action :initialize_online_retailer_user, only: :create
  load_and_authorize_resource  
  
  # GET /admin/online_retailer_users
  # GET /admin/online_retailer_users.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @online_retailer_users }
    end
  end

  # GET /admin/online_retailer_users/1
  # GET /admin/online_retailer_users/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @online_retailer_user }
    end
  end

  # GET /admin/online_retailer_users/new
  # GET /admin/online_retailer_users/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @online_retailer_user }
    end
  end

  # GET /admin/online_retailer_users/1/edit
  def edit
  end

  # POST /admin/online_retailer_users
  # POST /admin/online_retailer_users.xml
  def create
    @called_from = params[:called_from] || 'user'
    respond_to do |format|
      if @online_retailer_user.save
        format.html { redirect_to([:admin, @online_retailer_user], notice: 'User was successfully created.') }
        format.xml  { render xml: @online_retailer_user, status: :created, location: @online_retailer_user }
        format.js
        website.add_log(user: current_user, action: "Created #{@online_retailer_user.online_retailer.name} user: #{@online_retailer_user.user.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @online_retailer_user.errors, status: :unprocessable_entity }
        format.js { render plain: "Error"}
      end
    end
  end

  # PUT /admin/online_retailer_users/1
  # PUT /admin/online_retailer_users/1.xml
  def update
    respond_to do |format|
      if @online_retailer_user.update(online_retailer_user_params)
        format.html { redirect_to([:admin, @online_retailer_user.online_retailer], notice: 'User was successfully updated.') }
        format.xml  { head :ok }
        format.js
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @online_retailer_user.errors, status: :unprocessable_entity }
        format.js { render plain: "Error"}
      end
    end
  end

  # DELETE /admin/online_retailer_users/1
  # DELETE /admin/online_retailer_users/1.xml
  def destroy
    @online_retailer_user.destroy
    respond_to do |format|
      format.html { redirect_to(admin_online_retailer_users_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Removed user: #{@online_retailer_user.user.name} from #{@online_retailer_user.online_retailer.name}")
  end

  private

  def initialize_online_retailer_user
    @online_retailer_user = OnlineRetailer.new(online_retailer_user_params)
  end

  def online_retailer_user_params
    params.require(:online_retailer_user).permit!
  end
end
