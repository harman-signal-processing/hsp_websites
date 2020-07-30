class Admin::UsersController < AdminController
  before_action :initialize_user, only: :create
  load_and_authorize_resource
  
  # GET /admin/users
  # GET /admin/users.xml
  def index
    @search = User.ransack(params[:q])
    if params[:q]
      @users = @search.result.order(:name, :email)
    else
      @users = []
    end
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @users }
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.xml
  def show
    @online_retailer_user = OnlineRetailerUser.new(user: @user)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @user }
    end
  end

  # GET /admin/users/new
  # GET /admin/users/new.xml
  def new
    @user.invitation_code = ENV['EMPLOYEE_INVITATION_CODE']
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @user }
    end
  end

  # GET /admin/users/1/edit
  def edit
  end

  # POST /admin/users/1/reset_password
  def reset_password
    new_password = ENV['DEFAULT_PASSWORD']
    @user.password = new_password
    @user.password_confirmation = @user.password
    respond_to do |format|
      if @user.save
        format.html { redirect_to([:admin, @user], notice: "Password was reset to: #{new_password}")}
        format.xml { head :ok }
        website.add_log(user: current_user, action: "Reset password for #{@user.name}")
      end
    end
  end

  # POST /admin/users
  # POST /admin/users.xml
  def create
    #@user.skip_confirmation!
    respond_to do |format|
      if @user.save
        #@user.confirm
        format.html { redirect_to([:admin, @user], notice: 'User was successfully created.') }
        format.xml  { render xml: @user, status: :created, location: @user }
        website.add_log(user: current_user, action: "Created user: #{@user.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @user.errors, status: :unprocessable_entity }
      end
    end
  end
    
  # PUT /admin/users/1
  # PUT /admin/users/1.xml
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to([:admin, @user], notice: 'User was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated user #{@user.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.xml
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to(admin_users_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted user #{@user.name}")
  end

  private

  def initialize_user
    @user = User.new(user_params)
  end

  def user_params
    params.require(:user).permit!
  end
end
