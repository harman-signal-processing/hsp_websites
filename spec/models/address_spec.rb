require 'rails_helper'

RSpec.describe Address, type: :model do
  before(:all) do
    @address = FactoryBot.build_stubbed(:address)
  end

  subject { @address }
  it { should respond_to(:zipcode) }
  it { should respond_to(:city) }
  it { should respond_to(:state) }

  it "should determine if it is a US address" do
    address = FactoryBot.build_stubbed(:address, country: "United States of America")

    expect(address.is_us_address?).to be(true)
  end

  it "should determine if it has zip+4 or not" do
    address = FactoryBot.build_stubbed(:address, postal_code: "90210")
    expect(address.zipcode_has_plus4?).to be(false)

    address = FactoryBot.build_stubbed(:address, postal_code: "90210-1234")
    expect(address.zipcode_has_plus4?).to be(true)
  end
end
