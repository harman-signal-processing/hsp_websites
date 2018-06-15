require 'rails_helper'

RSpec.describe Vip::ProgrammerWebsite, type: :model do
  before do
  	@vip_programmer_website = FactoryBot.create(:vip_programmer_website)
  end
  context 'Validate ProgrammerWebsite' do
  	it 'ProgrammerWebsite should have position attribute' do
  		expect(@vip_programmer_website.position).to eq(1)
  	end
  end
end
