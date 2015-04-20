require 'rails_helper'

RSpec.describe Signup, :type => :model do

  before do
    @signup = FactoryGirl.create(:signup)
  end

  it "should not require name" do
    expect(@signup.valid?).to be(true)
  end

  describe "Crown Truck Tour registrations" do
    before do
      @signup.campaign = "Crown-TruckTour-#{Date.today.year}"
    end

    it "should require a name" do
      expect(@signup.valid?).to be(false)
    end

    it "should be valid with a first and last name" do
      @signup.first_name = "Johnny"
      @signup.last_name = "Johnson"

      expect(@signup.valid?).to be(true)
    end
  end

end
