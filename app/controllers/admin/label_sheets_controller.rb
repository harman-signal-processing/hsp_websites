class Admin::LabelSheetsController < AdminController
  before_action :initialize_label_sheet, only: :create
  load_and_authorize_resource

  # GET /label_sheets
  # GET /label_sheets.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @label_sheets }
    end
  end

  # GET /label_sheets/1
  # GET /label_sheets/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @label_sheet }
    end
  end

  # GET /label_sheets/new
  # GET /label_sheets/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @label_sheet }
    end
  end

  # GET /label_sheets/1/edit
  def edit
  end

  # POST /label_sheets
  # POST /label_sheets.xml
  def create
    respond_to do |format|
      if @label_sheet.save
        format.html { redirect_to([:admin, @label_sheet], notice: 'Label Sheet was successfully created.') }
        format.xml  { render xml: @label_sheet, status: :created, location: @label_sheet }
        website.add_log(user: current_user, action: "Created Label Sheet: #{@label_sheet.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @label_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /label_sheets/1
  # PUT /label_sheets/1.xml
  def update
    respond_to do |format|
      if @label_sheet.update_attributes(label_sheet_params)
        format.html { redirect_to([:admin, @label_sheet], notice: 'Label Sheet was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated Label Sheet: #{@label_sheet.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @label_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /label_sheets/1
  # DELETE /label_sheets/1.xml
  def destroy
    @label_sheet.destroy
    respond_to do |format|
      format.html { redirect_to(admin_label_sheets_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted Label Sheet: #{@label_sheet.name}")
  end

  private

  def initialize_label_sheet
    @label_sheet = LabelSheet.new(label_sheet_params)
  end

  def label_sheet_params
    params.require(:label_sheet).permit!
  end
end
