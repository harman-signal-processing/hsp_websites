require 'rails_helper'

RSpec.describe Address, type: :model do
  before(:all) do
    @address = build_stubbed(:address)
  end

  subject { @address }
  it { should respond_to(:zipcode) }
  it { should respond_to(:city) }
  it { should respond_to(:state) }

  it "should determine if it is a US address" do
    address = build_stubbed(:address, country: "United States of America")

    expect(address.is_us_address?).to be(true)
  end

  it "should determine if it has zip+4 or not" do
    address = build_stubbed(:address, postal_code: "90210")
    expect(address.zipcode_has_plus4?).to be(false)

    address = build_stubbed(:address, postal_code: "90210-1234")
    expect(address.zipcode_has_plus4?).to be(true)
  end

  it "provides attributes as an array" do
    expect(@address.to_a).to be_an(Array)
  end

  it "provides a string of attributes" do
    expect(@address.to_s).to be_a(String)
  end

  it "converts 5-digit zipcodes to 9-digit zipcodes" do
    address = build(:address)
    address.street_1 = "8500 Balboa Blvd."
    address.locality = "Northridge"
    address.region = "CA"
    address.postal_code = "91329"
    address.country = "United States of America"

    VCR.use_cassette("address_gets_zip4") do
      address.save
    end

    expect(address.postal_code.length).to eq(10)
  end

end
