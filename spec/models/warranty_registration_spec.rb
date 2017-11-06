require "rails_helper"

RSpec.describe WarrantyRegistration, :type => :model do

  before do
    @warranty_registration = FactoryBot.build(:warranty_registration)
  end

  subject { @warranty_registration }
  it { should respond_to(:brand) }

  describe "sync with service department" do
    it "should fill in form after creation" do
      expect(@warranty_registration).to receive(:sync_with_service_department)
      @warranty_registration.save
    end
  end
end
