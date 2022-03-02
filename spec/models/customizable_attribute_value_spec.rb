require 'rails_helper'

RSpec.describe CustomizableAttributeValue, type: :model do

  before do
    @customizable_attribute_value = build_stubbed(:customizable_attribute_value)
  end

  subject { @customizable_attribute_value }
  it { should respond_to(:product) }
  it { should respond_to(:customizable_attribute) }
end
