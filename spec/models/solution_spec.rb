require 'rails_helper'

RSpec.describe Solution, type: :model do
  before :all do
    @solution = FactoryGirl.build_stubbed(:solution)
  end

  subject { @solution }
  it { should respond_to :brand_solution_featured_products }
  it { should respond_to :brands }
  it { should respond_to :products }

end
