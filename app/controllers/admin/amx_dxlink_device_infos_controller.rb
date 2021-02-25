class Admin::AmxDxlinkDeviceInfosController < AdminController
  load_and_authorize_resource class: "AmxDxlinkDeviceInfo"
  
  def index
    @dxlink_device_list = AmxDxlinkDeviceInfo.all
    @dxlink_device_list_tx = AmxDxlinkDeviceInfo.where("type_short_name = ?", "tx").order(:model)
    @dxlink_device_list_rx = AmxDxlinkDeviceInfo.where("type_short_name = ?", "rx").order(:model)
    @amx_dxlink_combo = AmxDxlinkCombo.new
    @amx_dxlink_device_info = AmxDxlinkDeviceInfo.new
  end

  def new
    @amx_dxlink_device = AmxDxlinkDeviceInfo.new
  end

  def create
    @amx_dxlink_device = AmxDxlinkDeviceInfo.new(amx_dxlink_device_info_params)
    respond_to do |format|
      if @amx_dxlink_device.save
        format.html { redirect_to(admin_amx_dxlink_device_info_path(@amx_dxlink_device), notice: "AMX #{@amx_dxlink_device_info.model} #{@amx_dxlink_device_info.type_long_name} (#{@amx_dxlink_device_info.model_family}) was successfully created.") }
        website.add_log(user: current_user, action: "Created amx #{@amx_dxlink_device_info.model} #{@amx_dxlink_device_info.type_long_name} (#{@amx_dxlink_device_info.model_family})")
      else
        format.html { redirect_to(admin_amx_dxlink_device_infos_path, notice: "There was a problem creating the AMX #{@amx_dxlink_device_info.model} #{@amx_dxlink_device_info.type_long_name} (#{@amx_dxlink_device_info.model_family}).") }
      end
    end  #  respond_to do |format|
  end  #  def create

  def edit
    @amx_dxlink_device = AmxDxlinkDeviceInfo.find(params[:id])
  end

  def show
  end

  def update
    @amx_dxlink_device_info = AmxDxlinkDeviceInfo.find(params[:id])
    respond_to do |format|
      if @amx_dxlink_device_info.update(amx_dxlink_device_info_params)
        format.html { redirect_to(admin_amx_dxlink_device_infos_path, notice: "(#{@amx_dxlink_device_info.model_family}) #{@amx_dxlink_device_info.model} - #{@amx_dxlink_device_info.type_long_name} was successfully updated.") }
        website.add_log(user: current_user, action: "Updated amx dxlink device info: (#{@amx_dxlink_device_info.model_family}) #{@amx_dxlink_device_info.model} - #{@amx_dxlink_device_info.type_long_name}")
      else
        format.html { render action: "edit" }
      end
    end 
  end  
  
  # DELETE /amx_dxlink_device_infos/1
  def destroy
    @amx_dxlink_device_info.destroy
    respond_to do |format|
      format.html { redirect_to(admin_amx_dxlink_device_infos_url) }
    end
    website.add_log(user: current_user, action: "Deleted an amx dxlink device info: #{@amx_dxlink_device_info.model} #{@amx_dxlink_device_info.type_long_name} (#{@amx_dxlink_device_info.model_family})")
  end  
  
  private
  
    def amx_dxlink_device_info_params
      params.require(:amx_dxlink_device_info).permit(:model, :model_family, :type_long_name, :type_short_name, :product_url, :image_url)
    end
    
end  #  class Admin::AmxDxlinkDeviceInfosController < AdminController
