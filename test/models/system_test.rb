require "test_helper"

describe System do
  let(:system) { System.new }

  it "must be valid" do
    system.must_be :valid?
  end
end
