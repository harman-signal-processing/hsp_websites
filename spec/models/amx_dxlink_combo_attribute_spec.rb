require 'rails_helper'

RSpec.describe AmxDxlinkComboAttribute, type: :model do
  before do
    @amx_dxlink_combo_attribute = FactoryBot.create(:amx_dxlink_combo_attribute)
  end
  
  it 'AmxDxlinkComboAttributes should be unique to AmxDxlinkCombos' do
    existing_attribute_value = @amx_dxlink_combo_attribute.value
	  new_amx_dxlink_combo_attribute = AmxDxlinkComboAttribute.new(
	    amx_dxlink_combo_id: "#{@amx_dxlink_combo_attribute.amx_dxlink_combo_id}", 
	    amx_dxlink_attribute_name_id: "#{@amx_dxlink_combo_attribute.amx_dxlink_attribute_name_id}", 
	    value: "#{existing_attribute_value}")
	  expect(new_amx_dxlink_combo_attribute).not_to be_valid
  end
  
end
