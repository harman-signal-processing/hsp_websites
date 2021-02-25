class Admin::AmxDxlinkAttributeNamesController < AdminController
  before_action :initialize_dxlink_attribute_name, only: :create
  load_and_authorize_resource class: "AmxDxlinkAttributeName"
  
  def index
    @attibute_name_list = AmxDxlinkAttributeName.all.order(:position)
  end
  
  def create
    respond_to do |format|
      if @amx_dxlink_attribute_name.present?
        begin
          @amx_dxlink_attribute_name.save!
          format.html { redirect_to(admin_amx_dxlink_attribute_names_path, notice: "AMX #{@amx_dxlink_attribute_name.name} was successfully created.") }
          website.add_log(user: current_user, action: "Created amx dxlink attribute name: #{@amx_dxlink_attribute_name.name} ") 
        rescue => e
          @error = "Error: #{e.message}"
          # format.html { render template: "admin/amx_dxlink_attribute_names/create_error" }          
        end 
      else
        format.html { redirect_to(admin_amx_dxlink_device_infos_path, notice: "There was a problem creating the AMX dxlink attribute name: #{@amx_dxlink_attribute_name.name} ") }
      end  #  if @amx_dxlink_attribute_name.present?
    end  #  respond_to do |format|
  end  #  def create
  
  def edit
    @amx_dxlink_attribute_name = AmxDxlinkAttributeName.find(params[:id])
  end
  
  def update
    @amx_dxlink_attribute_name = AmxDxlinkAttributeName.find(params[:id])
    respond_to do |format|
      if @amx_dxlink_attribute_name.update(amx_dxlink_attribute_name_params)
        format.html { redirect_to(admin_amx_dxlink_attribute_names_path, notice: "(#{@amx_dxlink_attribute_name.name}) was successfully updated.") }
        website.add_log(user: current_user, action: "Updated amx dxlink attribute name: (#{@amx_dxlink_attribute_name.name}) ")
      else
        format.html { render action: "edit" }
      end
    end 
  end 
  
  def update_order
    update_list_order(AmxDxlinkAttributeName, params["amx_dxlink_attribute_name"]) # update_list_order is in application_controller
    head :ok
    website.add_log(user: current_user, action: "Sorted AMX DXLink Attribute Names")
  end  
  
  # DELETE /amx_dxlink_attribute_names/1
  def destroy
    @amx_dxlink_attribute_name.destroy
    respond_to do |format|
      format.html { redirect_to(admin_amx_dxlink_attribute_names_path) }
    end
    website.add_log(user: current_user, action: "Deleted an amx dxlink attribute name: #{@amx_dxlink_attribute_name.name}")
  end    
  
  private
    def initialize_dxlink_attribute_name
      @amx_dxlink_attribute_name = AmxDxlinkAttributeName.new(amx_dxlink_attribute_name_params)
    end

    def amx_dxlink_attribute_name_params
      params.require(:amx_dxlink_attribute_name).permit(:name)
    end
end  #  class Admin::AmxDxlinkAttributeNamesController < AdminController