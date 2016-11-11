require 'rails_helper'

RSpec.describe ProductSolution, type: :model do

  before :all do
    @ps = FactoryGirl.build_stubbed(:product_solution)
  end

  subject { @ps }
  it { should respond_to :product }
  it { should respond_to :solution }
end
