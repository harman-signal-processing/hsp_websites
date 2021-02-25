require 'rails_helper'

RSpec.describe AmxDxlinkCombo, type: :model do
  before do
    @amx_dxlink_combo = FactoryBot.create(:amx_dxlink_combo)
  end
  
  it 'AmxDxlinkCombos associations should be unique' do
    existing_tx = @amx_dxlink_combo.tx
    existing_rx = @amx_dxlink_combo.rx
	  new_amx_dxlink_combo = AmxDxlinkCombo.new(tx_id: "#{existing_tx.id}", rx_id: "#{existing_rx.id}")
	  expect(new_amx_dxlink_combo).not_to be_valid
	  expect(new_amx_dxlink_combo.errors.messages[:tx_id]+new_amx_dxlink_combo.errors.messages[:rx_id]).to include("has already been taken")    
  end  #  it 'AmxDxlinkCombos associations should be unique' do 
  
end
