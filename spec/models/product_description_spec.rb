require 'rails_helper'

RSpec.describe ProductDescription, type: :model do

  before :all do
    @product_description = FactoryGirl.create(:product_description)
  end

  subject { @product_description }
  it { should respond_to :product }
end

