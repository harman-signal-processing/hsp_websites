class Admin::RsoNavigationsController < AdminController
  load_and_authorize_resource
  # GET /rso_navigations
  # GET /rso_navigations.xml
  def index
    @rso_navigations = @rso_navigations.where(brand_id: website.brand_id).order("position")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @rso_navigations }
    end
  end

  # GET /rso_navigations/1
  # GET /rso_navigations/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @rso_navigation }
    end
  end

  # GET /rso_navigations/new
  # GET /rso_navigations/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @rso_navigation }
    end
  end

  # GET /rso_navigations/1/edit
  def edit
  end

  # POST /rso_navigations
  # POST /rso_navigations.xml
  def create
    @rso_navigation.brand_id = (@rso_navigation.rso_panel) ? 0 : website.brand_id
    respond_to do |format|
      if @rso_navigation.save
        format.html { 
          if @rso_navigation.rso_panel
            redirect_to([:admin, @rso_navigation.rso_panel], notice: 'Element was successfully created.')
          else
            redirect_to([:admin, @rso_navigation], notice: 'Element was successfully created.') 
          end
        }
        format.xml  { render xml: @rso_navigation, status: :created, location: @rso_navigation }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @rso_navigation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rso_navigations/1
  # PUT /rso_navigations/1.xml
  def update
    respond_to do |format|
      if @rso_navigation.update_attributes(params[:rso_navigation])
        format.html { 
          if @rso_navigation.rso_panel
            redirect_to([:admin, @rso_navigation.rso_panel], notice: "Element was successfully updated.")
          else
            redirect_to([:admin, @rso_navigation], notice: 'Element was successfully updated.') 
          end
        }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @rso_navigation.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /admin/rso_navigations/update_order
  def update_order
    update_list_order(RsoNavigation, params["rso_navigation"])
    render nothing:true
  end

  # DELETE /rso_navigations/1
  # DELETE /rso_navigations/1.xml
  def destroy
    @rso_navigation.destroy
    respond_to do |format|
      format.html { 
        if @rso_navigation.rso_panel
          redirect_to([:admin, @rso_navigation.rso_panel])
        else
          redirect_to(admin_rso_navigations_url) 
        end
      }
      format.xml  { head :ok }
    end
  end
end
