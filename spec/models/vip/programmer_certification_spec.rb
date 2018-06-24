require 'rails_helper'

RSpec.describe Vip::ProgrammerCertification, type: :model do
  before do
  	@vip_programmer_certification = FactoryBot.create(:vip_programmer_certification)
  end
  context 'Validate ProgrammerCertification' do
  	it 'ProgrammerCertification should have position attribute' do
  		expect(@vip_programmer_certification.position).to eq(1)
  	end
  end
end
