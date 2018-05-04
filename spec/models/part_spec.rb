require 'rails_helper'

RSpec.describe Part, type: :model do
  before do
    @part = FactoryBot.build_stubbed(:part)
  end

  subject { @part }
  it { should respond_to(:part_number) }
  it { should respond_to(:description) }
  it { should respond_to(:photo) }
  it { should respond_to(:product_parts) }
  it { should respond_to(:products) }
  it { should respond_to(:parent) }
end
