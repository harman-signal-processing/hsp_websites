require 'rails_helper'

RSpec.describe OperatingSystem, :type => :model do

  before do
    @operating_system = create(:operating_system)
  end

  subject { @operating_system }
  it { should respond_to :softwares }
  it { should respond_to :software_operating_systems }

  describe "building formatted name" do
    it "should combine fields" do
      os = build(:operating_system, name: "GoodOS", version: "99", arch: "ti")

      fn = os.formatted_name

      expect(fn).to eq("GoodOS 99 ti")
    end
  end
end

