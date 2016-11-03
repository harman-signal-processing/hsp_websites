require 'rails_helper'

RSpec.describe ProductVideo, type: :model do

  before :all do
    @product_video = FactoryGirl.create(:product_video)
  end

  subject { @product_video }
  it { should respond_to :product }
end
