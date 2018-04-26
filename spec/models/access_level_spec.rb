require 'rails_helper'

RSpec.describe AccessLevel, type: :model do

  before do
    @access_level = FactoryBot.create(:access_level)
  end

  subject { @access_level }
  it { should respond_to :name }
  it { should respond_to :long_name }
  it { should respond_to :dealer_access? }
  it { should respond_to :distributor_access? }
  it { should respond_to :technician_access? }

  it "should allow access to users with matching role" do
    user = FactoryBot.build_stubbed(:user, technician: true)
    technician_level = FactoryBot.build_stubbed(:access_level, technician: true)

    expect(technician_level.readable_by?(user)).to be(true)
  end

  it "should not allow access to users without matching role" do
    user = FactoryBot.build_stubbed(:user, distributor: true, technician: false)
    technician_level = FactoryBot.build_stubbed(:access_level, technician: true)

    expect(technician_level.readable_by?(user)).to be(false)
  end
end
