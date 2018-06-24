require 'rails_helper'

RSpec.describe Vip::ProgrammerSkill, type: :model do
  before do
  	@vip_programmer_skill = FactoryBot.create(:vip_programmer_skill)
  end
  context 'Validate ProgrammerSkill' do
  	it 'ProgrammerSkill should have position attribute' do
  		expect(@vip_programmer_skill.position).to eq(1)
  	end
  end
end
