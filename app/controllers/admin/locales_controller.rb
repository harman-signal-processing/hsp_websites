class Admin::LocalesController < AdminController
  before_action :initialize_locale, only: :create
  load_and_authorize_resource

  # GET /locales
  # GET /locales.xml
  def index
    @locales = @locales.order(:locale_type_id)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @locales }
    end
  end

  # GET /locales/1
  # GET /locales/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @locale }
    end
  end

  # GET /locales/new
  # GET /locales/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @locale }
    end
  end

  # GET /locales/1/edit
  def edit
  end

  # POST /locales
  # POST /locales.xml
  def create
    respond_to do |format|
      if @locale.save
        format.html { redirect_to([:admin, @locale], notice: 'Locale was successfully created.') }
        format.xml  { render xml: @locale, status: :created, location: @locale }
        website.add_log(user: current_user, action: "Created locale: #{@locale.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @locale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locales/1
  # PUT /locales/1.xml
  def update
    respond_to do |format|
      if @locale.update(locale_params)
        format.html { redirect_to([:admin, @locale], notice: 'Locale was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated locale: #{@locale.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @locale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locales/1
  # DELETE /locales/1.xml
  def destroy
    @locale.destroy
    respond_to do |format|
      format.html { redirect_to(admin_locales_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted locale: #{@locale.name}")
  end

  private

  def initialize_locale
    @locale = Locale.new(locale_params)
  end

  def locale_params
    params.require(:locale).permit(:code, :name)
  end
end
