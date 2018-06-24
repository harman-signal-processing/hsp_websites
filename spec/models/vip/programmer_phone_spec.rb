require 'rails_helper'

RSpec.describe Vip::ProgrammerPhone, type: :model do
  before do
  	@vip_programmer_phone = FactoryBot.create(:vip_programmer_phone)
  end
  context 'Validate ProgrammerPhone' do
  	it 'ProgrammerPhone should have position attribute' do
  		expect(@vip_programmer_phone.position).to eq(1)
  	end
  end
  
end
