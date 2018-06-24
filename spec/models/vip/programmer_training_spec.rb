require 'rails_helper'

RSpec.describe Vip::ProgrammerTraining, type: :model do
  before do
  	@vip_programmer_training = FactoryBot.create(:vip_programmer_training)
  end
  context 'Validate ProgrammerTraining' do
  	it 'ProgrammerTraining should have position attribute' do
  		expect(@vip_programmer_training.position).to eq(1)
  	end
  end
end
