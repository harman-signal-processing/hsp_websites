require 'rails_helper'

RSpec.describe Innovation, type: :model do
  before do
    @innovation = FactoryBot.build_stubbed(:innovation)
  end

  subject { @innovation }
  it { should respond_to(:brand) }
  it { should respond_to(:products) }
  it { should respond_to(:icon) }
end
