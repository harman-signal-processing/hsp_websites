require 'rails_helper'

RSpec.describe AmxDxlinkDeviceInfo, type: :model do
  before do
    @amx_dxlink_device_info = FactoryBot.create(:amx_dxlink_device_info)
  end
  
  context 'Validate attributes' do
    it { should respond_to(:model) }
    it { should respond_to(:model_family) }
    it { should respond_to(:type_long_name) }
    it { should respond_to(:type_short_name) }
    it { should respond_to(:product_url) }
    it { should respond_to(:image_url) }
  end
  
end
