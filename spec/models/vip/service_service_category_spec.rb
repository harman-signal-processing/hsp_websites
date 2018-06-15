require 'rails_helper'

RSpec.describe Vip::ServiceServiceCategory, type: :model do
  context 'Validate ServiceServiceCategory has position' do
    before do
      @vip_service_service_category = FactoryBot.create(:vip_service_service_category)
    end
    
    it 'ServiceServiceCategory has postition attribute' do
      expect(@vip_service_service_category.position).to eq(1)
    end
    
  end
end
