class Admin::AmxDxlinkComboAttributesController < AdminController
  load_and_authorize_resource class: "AmxDxlinkComboAttribute"
  
  def index
  end
  
  def bulk_update
    amx_dxlink_combo = AmxDxlinkCombo.find(params[:amx_dxlink_combo_id])
    recommended = params[:amx_dxlink_combo][:recommended]
    amx_dxlink_combo.update_attribute(:recommended, recommended)
    calling_device = params[:calling_device]

    # delete all the existing attributes for this combo, we'll recreate them below
    amx_dxlink_combo.combo_attributes.delete_all

    attribute_name_ids = params[:attribute_name_ids]
    attribute_values = params[:attribute_values]
    attributes_hash = Hash[attribute_name_ids.zip(attribute_values)]

    success_count = 0
    attributes_hash.each do |key,value|
      attr = AmxDxlinkComboAttribute.new(amx_dxlink_attribute_name_id: key, value: value, amx_dxlink_combo_id: amx_dxlink_combo.id)
      save_successful = attr.save!
      success_count += 1 if save_successful
    end

    if (success_count == attributes_hash.count)
      website.add_log(user: current_user, action: "Updated AMX DXLink Pairing Compatibility Attributes: #{amx_dxlink_combo.tx.model} - #{amx_dxlink_combo.rx.model}")
      redirect_to(admin_amx_dxlink_combo_path(amx_dxlink_combo, calling_device: calling_device), notice: 'AMX DXLink Pairing Compatibility Attributes were successfully updated.')
    else
      redirect_to([:admin, amx_dxlink_combo], notice: "AMX DXLink Pairing Compatibility Attributes update failed. #{amx_dxlink_combo.tx.model} - #{amx_dxlink_combo.rx.model}")
    end

  end  #  def bulk_update

  private
  
    def amx_dxlink_combo_attribute_params
      params.require(:amx_dxlink_combo_attribute).permit!
    end
  
end  #  class Admin::AmxDxlinkComboAttributesController < AdminController
