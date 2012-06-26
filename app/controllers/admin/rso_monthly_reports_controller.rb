class Admin::RsoMonthlyReportsController < AdminController
  load_and_authorize_resource
  # GET /rso_monthly_reports
  # GET /rso_monthly_reports.xml
  def index
    @rso_monthly_reports = @rso_monthly_reports.where(:brand_id => website.brand_id).order("created_at DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rso_monthly_reports }
    end
  end

  # GET /rso_monthly_reports/1
  # GET /rso_monthly_reports/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rso_monthly_report }
    end
  end

  # GET /rso_monthly_reports/new
  # GET /rso_monthly_reports/new.xml
  def new
    @rso_monthly_report.add_to_panel = true
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rso_monthly_report }
    end
  end

  # GET /rso_monthly_reports/1/edit
  def edit
  end

  # POST /rso_monthly_reports
  # POST /rso_monthly_reports.xml
  def create
    @rso_monthly_report.brand_id = website.brand_id
    @rso_monthly_report.updated_by_id = current_user.id
    respond_to do |format|
      if @rso_monthly_report.save
        format.html { redirect_to([:admin, @rso_monthly_report], :notice => 'RSO monthly report was successfully created.') }
        format.xml  { render :xml => @rso_monthly_report, :status => :created, :location => @rso_monthly_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rso_monthly_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rso_monthly_reports/1
  # PUT /rso_monthly_reports/1.xml
  def update
    @rso_monthly_report.updated_by_id = current_user.id
    respond_to do |format|
      if @rso_monthly_report.update_attributes(params[:rso_monthly_report])
        format.html { redirect_to([:admin, @rso_monthly_report], :notice => 'RSO monthly report was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rso_monthly_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rso_monthly_reports/1
  # DELETE /rso_monthly_reports/1.xml
  def destroy
    @rso_monthly_report.destroy
    respond_to do |format|
      format.html { redirect_to(admin_rso_monthly_reports_url) }
      format.xml  { head :ok }
    end
  end
end
