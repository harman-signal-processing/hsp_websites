class Admin::UsersController < AdminController
  load_and_authorize_resource
  # GET /admin/users
  # GET /admin/users.xml
  def index
    @users = @users.order(:email)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.xml
  def show
    @online_retailer_user = OnlineRetailerUser.new(:user => @user)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/users/new
  # GET /admin/users/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/users/1/edit
  def edit
  end
  
  # POST /admin/users/1/reset_password
  def reset_password
    new_password = "Hsp123!"
    @user.password = new_password
    @user.password_confirmation = @user.password
    respond_to do |format|
      if @user.save
        format.html { redirect_to([:admin, @user], :notice => "Password was reset to: #{new_password}")}
        format.xml { head :ok }
      end
    end
  end

  # POST /admin/users
  # POST /admin/users.xml
  def create
    respond_to do |format|
      if @user.save
        format.html { redirect_to([:admin, @user], :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  # PUT /admin/users/1
  # PUT /admin/users/1.xml
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to([:admin, @user], :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
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
  end
end
