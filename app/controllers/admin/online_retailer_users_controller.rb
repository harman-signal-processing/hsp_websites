class Admin::OnlineRetailerUsersController < AdminController
  load_and_authorize_resource  
  # GET /admin/online_retailer_users
  # GET /admin/online_retailer_users.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render :xml => @online_retailer_users }
    end
  end

  # GET /admin/online_retailer_users/1
  # GET /admin/online_retailer_users/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @online_retailer_user }
    end
  end

  # GET /admin/online_retailer_users/new
  # GET /admin/online_retailer_users/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @online_retailer_user }
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
        format.html { redirect_to([:admin, @online_retailer_user], :notice => 'User was successfully created.') }
        format.xml  { render :xml => @online_retailer_user, :status => :created, :location => @online_retailer_user }
        format.js 
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @online_retailer_user.errors, :status => :unprocessable_entity }
        format.js { render :text => "Error"}
      end
    end
  end

  # PUT /admin/online_retailer_users/1
  # PUT /admin/online_retailer_users/1.xml
  def update
    respond_to do |format|
      if @online_retailer_user.update_attributes(params[:online_retailer_user])
        format.html { redirect_to([:admin, @online_retailer_user.online_retailer], :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
        format.js 
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @online_retailer_user.errors, :status => :unprocessable_entity }
        format.js { render :text => "Error"}
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
  end
end
