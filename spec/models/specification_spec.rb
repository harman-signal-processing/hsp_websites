require 'rails_helper'

RSpec.describe Specification, type: :model do

  before :all do
    @specification = FactoryGirl.create(:specification)
  end

  subject { @specification }
  it { should respond_to(:name) }
  it { should respond_to(:product_specifications) }
  it { should respond_to(:specification_group) }
end

