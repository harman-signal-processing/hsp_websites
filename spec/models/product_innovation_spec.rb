require 'rails_helper'

RSpec.describe ProductInnovation, type: :model do
  before do
    @product_innovation = FactoryBot.build_stubbed(:product_innovation)
  end

  subject { @product_innovation }
  it { should respond_to(:innovation) }
  it { should respond_to(:product) }
end
