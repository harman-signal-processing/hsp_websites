class Admin::ClinicianReportsController < AdminController
  load_and_authorize_resource
  # GET /clinician_reports
  # GET /clinician_reports.xml
  def index
    @clinician_reports ||= []
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @clinician_reports }
    end
  end

  # GET /clinician_reports/1
  # GET /clinician_reports/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @clinician_report }
    end
  end

  # GET /clinician_reports/new
  # GET /clinician_reports/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @clinician_report }
    end
  end

  # GET /clinician_reports/1/edit
  def edit
    @clinician_report.clinic.clinic_products.build
    (4 - @clinician_report.clinician_questions.size.to_i).times do
      @clinician_report.clinician_questions.build
    end
  end

  # POST /clinician_reports
  # POST /clinician_reports.xml
  def create
    respond_to do |format|
      if @clinician_report.save
        format.html { redirect_to([:admin, @clinician_report.clinic], notice: 'Clinician report was successfully created.') }
        format.xml  { render xml: @clinician_report, status: :created, location: @clinician_report }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @clinician_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clinician_reports/1
  # PUT /clinician_reports/1.xml
  def update
    respond_to do |format|
      if @clinician_report.update_attributes(params[:clinician_report])
        format.html { redirect_to([:admin, @clinician_report.clinic], notice: 'Clinician report was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @clinician_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clinician_reports/1
  # DELETE /clinician_reports/1.xml
  def destroy
    @clinician_report.destroy
    respond_to do |format|
      format.html { redirect_to(admin_clinician_reports_url) }
      format.xml  { head :ok }
    end
  end

end
