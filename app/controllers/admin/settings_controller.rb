class Admin::SettingsController < AdminController
  load_and_authorize_resource

  # GET /admin/settings
  # GET /admin/settings.xml
  def index
    @settings = @settings.where(brand_id: website.brand_id).order("locale, setting_type, name")
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @settings }
    end
  end
  
  def homepage
    @slides = Setting.slides(website)
    @new_slide = Setting.new(setting_type: "slideshow frame")
    if @slides.size > 0
      begin
        @new_slide.integer_value = @slides.last.integer_value + 1
      rescue
        @new_slide.integer_value = 1
      end
    end
    @features = Setting.features(website)
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
      Setting.find_or_initialize_by_brand_id_and_name_and_setting_type(website.brand_id, "homepage_column_1", "string"),
      Setting.find_or_initialize_by_brand_id_and_name_and_setting_type(website.brand_id, "homepage_column_2", "string"),
      Setting.find_or_initialize_by_brand_id_and_name_and_setting_type(website.brand_id, "homepage_column_3", "string"),
      Setting.find_or_initialize_by_brand_id_and_name_and_setting_type(website.brand_id, "homepage_column_4", "string")
    ]
  end
  
  # POST /admin/big_bottom_box
  # updates the content in the big bottom box on the homepage
  def big_bottom_box
    @columns = params[:settings][:setting]
    # render inline: "#{@columns.first[1]}"
    @columns.each do |column_data|
      column = Setting.find_or_initialize_by_brand_id_and_name(website.brand_id, column_data[1][:name])
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
    render nothing: true
    website.add_log(user: current_user, action: "Updated homepage slides order")
  end

  def update_features_order
    order = params["feature"]
    order.to_a.each_with_index do |item, pos|
      Setting.update(item, integer_value: (pos + 1))
    end
    render nothing: true
    website.add_log(user: current_user, action: "Updated homepage features order")
  end
  
  def copy
    @setting = Setting.find(params[:id]).dup
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
      if @setting.update_attributes(params[:setting])
        red = (params[:called_from] && params[:called_from] == "homepage") ? homepage_admin_settings_path : [:admin, @setting]
        format.html { redirect_to(red, notice: 'Setting was successfully updated.') }
        format.xml  { head :ok }
        format.js 
        website.add_log(user: current_user, action: "Updated setting: #{@setting.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @setting.errors, status: :unprocessable_entity }
        format.js   { render nothing: true}
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
  
end
