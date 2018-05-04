require 'rails_helper'

RSpec.describe ProductPart, type: :model do
  before do
    @product_part = FactoryBot.build_stubbed(:product_part)
  end

  subject { @product_part }
  it { should respond_to(:part) }
  it { should respond_to(:product) }
end
