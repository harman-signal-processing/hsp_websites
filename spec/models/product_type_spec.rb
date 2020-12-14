require 'rails_helper'

RSpec.describe ProductType, type: :model do

  before do
    @product_type = FactoryBot.build_stubbed(:product_type)
  end

  subject { @product_type }
  it { should respond_to(:name) }
  it { should respond_to(:default) }
  it { should respond_to(:digital_ecom) }

  it "should find a default" do
    default_product_type = FactoryBot.create(:standard_product_type)
    expect(ProductType.default).to eq(default_product_type)
  end

  it "should find the digital ecom type" do
    digital_ecom_type = FactoryBot.create(:ecommerce_digital_download_product_type)
    expect(ProductType.digital_ecom).to eq(digital_ecom_type)
  end
end
