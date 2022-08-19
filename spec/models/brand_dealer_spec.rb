require 'rails_helper'

RSpec.describe BrandDealer, type: :model do
  before do
    @brand_dealer = FactoryBot.create(:brand_dealer)
  end

  subject { @brand_dealer }
  it { should respond_to(:brand) }
  it { should respond_to(:dealer) }
end

