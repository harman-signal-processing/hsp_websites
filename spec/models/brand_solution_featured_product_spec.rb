require 'rails_helper'

RSpec.describe BrandSolutionFeaturedProduct, type: :model do

  before :all do
    @bsfp = FactoryGirl.build_stubbed(:brand_solution_featured_product)
  end

  subject { @bsfp }
  it { should respond_to :brand }
  it { should respond_to :solution }
  it { should respond_to :product }
  it { should respond_to :link }
  it { should respond_to :image }
end
