class Admin::LocalesController < AdminController
  before_action :initialize_locale, only: :create
  #load_and_authorize_resource

  # GET /locales
  # GET /locales.xml
  def index
    @locales = Locale.order(:locale_type_id)
    authorize! :read, @locales
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @locales }
    end
  end

  # GET /locales/1
  # GET /locales/1.xml
  def show
    @this_locale = Locale.find(params[:id])
    authorize! :read, @this_locale
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @this_locale }
    end
  end

  # GET /locales/new
  # GET /locales/new.xml
  def new
    @this_locale = Locale.new
    authorize! :create, @this_locale
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @this_locale }
    end
  end

  # GET /locales/1/edit
  def edit
    @this_locale = Locale.find(params[:id])
    authorize! :update, @this_locale
  end

  # POST /locales
  # POST /locales.xml
  def create
    @this_locale = Locale.new(locale_params)
    authorize! :create, @this_locale
    respond_to do |format|
      if @this_locale.save
        Rails.application.reload_routes!
        format.html { redirect_to([:admin, @this_locale], notice: 'Locale was successfully created.') }
        format.xml  { render xml: @this_locale, status: :created, location: @this_locale }
        website.add_log(user: current_user, action: "Created locale: #{@this_locale.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @this_locale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locales/1
  # PUT /locales/1.xml
  def update
    @this_locale = Locale.find(params[:id])
    authorize! :update, @this_locale
    respond_to do |format|
      if @this_locale.update(locale_params)
        Rails.application.reload_routes!
        format.html { redirect_to([:admin, @this_locale], notice: 'Locale was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated locale: #{@this_locale.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @this_locale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locales/1
  # DELETE /locales/1.xml
  def destroy
    @this_locale = Locale.find(params[:id])
    authorize! :destroy, @this_locale
    @this_locale.destroy
    respond_to do |format|
      format.html { redirect_to(admin_locales_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted locale: #{@this_locale.name}")
  end

  private

  def initialize_locale
    @this_locale = Locale.new(locale_params)
  end

  def locale_params
    params.require(:this_locale).permit(:code, :name)
  end
end
