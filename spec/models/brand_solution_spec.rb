require 'rails_helper'

RSpec.describe BrandSolution, type: :model do

  before :all do
    @bs = FactoryGirl.build_stubbed(:brand_solution)
  end

  subject { @bs }
  it { should respond_to :brand }
  it { should respond_to :solution }
end
