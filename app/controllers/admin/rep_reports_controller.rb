class Admin::RepReportsController < AdminController
  load_and_authorize_resource
  # GET /rep_reports
  # GET /rep_reports.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rep_reports }
    end
  end

  # GET /rep_reports/1
  # GET /rep_reports/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rep_report }
    end
  end

  # GET /rep_reports/new
  # GET /rep_reports/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rep_report }
    end
  end

  # GET /rep_reports/1/edit
  def edit
    (4 - @rep_report.rep_questions.size.to_i).times do
      @rep_report.rep_questions.build
    end
  end

  # POST /rep_reports
  # POST /rep_reports.xml
  def create
    respond_to do |format|
      if @rep_report.save
        format.html { redirect_to([:admin, @rep_report.clinic], :notice => 'Rep report was successfully created.') }
        format.xml  { render :xml => @rep_report, :status => :created, :location => @rep_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rep_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rep_reports/1
  # PUT /rep_reports/1.xml
  def update
    respond_to do |format|
      if @rep_report.update_attributes(params[:rep_report])
        format.html { redirect_to([:admin, @rep_report.clinic], :notice => 'Rep report was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rep_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rep_reports/1
  # DELETE /rep_reports/1.xml
  def destroy
    @rep_report.destroy
    respond_to do |format|
      format.html { redirect_to(admin_rep_reports_url) }
      format.xml  { head :ok }
    end
  end

end
