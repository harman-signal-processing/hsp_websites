require 'rails_helper'

RSpec.describe Vip::ProgrammerEmail, type: :model do
  before do
  	@vip_programmer_email = FactoryBot.create(:vip_programmer_email)
  end
  context 'Validate ProgrammerEmail' do
  	it 'ProgrammerEmail should have position attribute' do
  		expect(@vip_programmer_email.position).to eq(1)
  	end
  end
end
