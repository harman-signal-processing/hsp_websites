require "rails_helper"

RSpec.describe ProductDocument, :type => :model do

  before do
    @product_document = FactoryBot.build_stubbed(:product_document)
  end

  subject { @product_document }
  it { should respond_to(:name) }
  it { should respond_to(:name_override) }

  it "#name loads overridden name if present" do
    @product_document.name_override = "COOLEST FILE EVER"

    expect(@product_document.name).to eq(@product_document.name_override)
  end

  it "#name generates a name" do
    @product_document.name_override = nil

    expect(@product_document.name).to be_an_instance_of(String)
  end

end
