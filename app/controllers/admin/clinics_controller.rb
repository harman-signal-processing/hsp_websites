class Admin::ClinicsController < AdminController
  load_and_authorize_resource
  
  # GET /clinics
  # GET /clinics.xml
  def index
    @clinics = @clinics.where(brand_id: website.brand_id)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @clinics }
    end
  end

  # GET /clinics/1
  # GET /clinics/1.xml
  def show
    @clinic.clinic_products.build
    (3 - @clinic.clinic_products.size.to_i).times do
      @clinic.clinic_products.build
    end        
    @clinician_report = ClinicianReport.new(clinic: @clinic)
    4.times do
      @clinician_report.clinician_questions.build
    end
    @rep_report = RepReport.new(clinic: @clinic)
    4.times do
      @rep_report.rep_questions.build
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @clinic }
    end
  end

  # GET /clinics/new
  # GET /clinics/new.xml
  def new
    3.times do
      @clinic.clinic_products.build
    end
    @clinic.rep = current_user
    @clinic.clinician = current_user
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @clinic }
    end
  end

  # GET /clinics/1/edit
  def edit
    (3 - @clinic.clinic_products.size.to_i).times do
      @clinic.clinic_products.build
    end
  end

  # POST /clinics
  # POST /clinics.xml
  def create
    @clinic.brand_id ||= website.brand_id
    respond_to do |format|
      if @clinic.save
        format.html { redirect_to([:admin, @clinic], notice: 'Clinic was successfully created.') }
        format.xml  { render xml: @clinic, status: :created, location: @clinic }
        website.add_log(user: current_user, action: "Created #{@clinic.location} clinic")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @clinic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clinics/1
  # PUT /clinics/1.xml
  def update
    respond_to do |format|
      if @clinic.update_attributes(params[:clinic])
        format.html { redirect_to([:admin, @clinic], notice: 'Clinic was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated #{@clinic.location} clinic")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @clinic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clinics/1
  # DELETE /clinics/1.xml
  def destroy
    @clinic.destroy
    respond_to do |format|
      format.html { redirect_to(admin_clinics_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted #{@clinic.location} clinic")
  end

end
