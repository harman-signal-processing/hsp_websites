require 'rails_helper'

RSpec.describe CustomizableAttribute, type: :model do
  before do
    @customizable_attribute = build_stubbed(:customizable_attribute)
  end

  subject { @customizable_attribute }
  it { should respond_to(:name) }
  it { should respond_to(:product_families) }
end
