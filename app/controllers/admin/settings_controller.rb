class Admin::SettingsController < AdminController
  before_action :initialize_setting, only: :create
  load_and_authorize_resource except: :new

  # GET /admin/settings
  # GET /admin/settings.xml
  def index
    @settings = @settings.where(brand_id: website.brand_id).order("locale, Upper(name)")
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @settings }
    end
  end

  def homepage
    @slides = Setting.slides(website, showall: true)
    @new_slide = Setting.new(setting_type: "slideshow frame")
    if @slides.size > 0
      begin
        @new_slide.integer_value = @slides.last.integer_value + 1
      rescue
        @new_slide.integer_value = 1
      end
    end
    @features = Setting.features(website, showall: true)
    @new_feature = Setting.new(setting_type: "homepage feature")
    if @features.size > 0
      begin
        @new_feature.integer_value = @features.last.integer_value + 1
      rescue
        @new_feature.integer_value = 1
      end
    end
    @column_options = [
      ["News (comes from the news on this site)", "news"],
      ["Facebook Feed (provide your Facebook url as setting: 'facebook')", "facebook"],
      ["Youtube Feed (provide your Youtube ID as setting: 'youtube')", "youtube"],
      ["Twitter Feed (provide your twitter name as setting 'twitter')", "twitter"],
      ["Featured Artists", "artists"],
      ["Where To Buy", "where_to_buy"]
    ]
    @columns = [
      Setting.where(brand_id: website.brand_id, name: "homepage_column_1", setting_type: "string").first_or_initialize,
      Setting.where(brand_id: website.brand_id, name: "homepage_column_2", setting_type: "string").first_or_initialize,
      Setting.where(brand_id: website.brand_id, name: "homepage_column_3", setting_type: "string").first_or_initialize,
      Setting.where(brand_id: website.brand_id, name: "homepage_column_4", setting_type: "string").first_or_initialize
    ]
  end

  # POST /admin/big_bottom_box
  # updates the content in the big bottom box on the homepage
  def big_bottom_box
    @columns = params[:settings][:setting]
    # render inline: "#{@columns.first[1]}"
    @columns.each do |column_data|
      column = Setting.where(brand_id: website.brand_id, name: column_data[1][:name]).first_or_initialize
      column.attributes = column_data[1]
      column.save
    end
    redirect_to homepage_admin_settings_path, notice: "Settings were saved"
    website.add_log(user: current_user, action: "Updated settings for big bottom box")
  end

  def update_slides_order
    order = params["setting"]
    order.to_a.each_with_index do |item, pos|
      Setting.update(item, integer_value: (pos + 1))
    end
    head :ok
    website.add_log(user: current_user, action: "Updated homepage slides order")
  end

  def update_features_order
    order = params["feature"]
    order.to_a.each_with_index do |item, pos|
      Setting.update(item, integer_value: (pos + 1))
    end
    head :ok
    website.add_log(user: current_user, action: "Updated homepage features order")
  end

  def copy
    @setting = Setting.find(params[:id]).dup
    if current_user.roles.include?(:translator)
      if current_user.locales.length > 0
        @setting.locale = current_user.locale.first
      end
    end
    respond_to do |format|
      format.html { render action: "new" }
      format.xml  { render xml: @setting }
    end
  end

  # GET /admin/settings/1
  # GET /admin/settings/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @setting }
    end
  end

  # GET /admin/settings/new
  # GET /admin/settings/new.xml
  def new
    @setting = Setting.new
    if current_user.roles.include?("translator")
      if current_user.locales.length > 0
        @setting.locale = current_user.locales.first
      end
    elsif params[:name]
      other = Setting.where(name: params[:name]).where.not(brand_id: website.brand_id).limit(1)
      if other.count > 0
        @setting = other.first.dup
        @setting.brand_id = website.brand_id
      end
    end
    authorize! :new, @setting
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @setting }
    end
  end

  # GET /admin/settings/1/edit
  def edit
  end

  # POST /admin/settings
  # POST /admin/settings.xml
  def create
    respond_to do |format|
      @setting.brand_id ||= website.brand_id
      if @setting.save
        red = (params[:called_from] && params[:called_from] == "homepage") ? homepage_admin_settings_path : [:admin, @setting]
        format.html { redirect_to(red, notice: 'Setting was successfully created.') }
        format.xml  { render xml: @setting, status: :created, location: @setting }
        website.add_log(user: current_user, action: "Created a new setting: #{@setting.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/settings/1
  # PUT /admin/settings/1.xml
  def update
    respond_to do |format|
      if @setting.update_attributes(setting_params)
        red = (params[:called_from] && params[:called_from] == "homepage") ? homepage_admin_settings_path : [:admin, @setting]
        format.html { redirect_to(red, notice: 'Setting was successfully updated.') }
        format.xml  { head :ok }
        format.js
        website.add_log(user: current_user, action: "Updated setting: #{@setting.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @setting.errors, status: :unprocessable_entity }
        format.js   { head :ok }
      end
    end
  end

  # DELETE /admin/settings/1
  # DELETE /admin/settings/1.xml
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to(admin_settings_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted setting: #{@setting.name}")
  end

  private

  def initialize_setting
    @setting = Setting.new(setting_params)
  end

  def setting_params
    params.require(:setting).permit!
  end
end
