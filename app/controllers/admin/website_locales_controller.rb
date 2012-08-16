class Admin::WebsiteLocalesController < AdminController
  load_and_authorize_resource
  # GET /website_locales
  # GET /website_locales.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @website_locales }
    end
  end

  # GET /website_locales/1
  # GET /website_locales/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @website_locale }
    end
  end

  # GET /website_locales/new
  # GET /website_locales/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @website_locale }
    end
  end

  # GET /website_locales/1/edit
  def edit
  end

  # POST /website_locales
  # POST /website_locales.xml
  def create
    respond_to do |format|
      if @website_locale.save
        format.html { redirect_to([:admin, @website_locale.website], notice: 'Locale was successfully created.') }
        format.xml  { render xml: @website_locale, status: :created, location: @website_locale }
        format.js
      else
        format.html { render action: "new" }
        format.xml  { render xml: @website_locale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /website_locales/1
  # PUT /website_locales/1.xml
  def update
    respond_to do |format|
      if @website_locale.update_attributes(params[:website_locale])
        format.html { redirect_to([:admin, @website_locale.website], notice: 'Locale was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @website_locale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /website_locales/1
  # DELETE /website_locales/1.xml
  def destroy
    @website_locale.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @website_locale.website]) }
      format.xml  { head :ok }
      format.js
    end
  end
end
