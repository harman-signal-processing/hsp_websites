require "minitest_helper"

describe ToolkitResource do
  # fixtures :all

  before do
    @toolkit_resource = ToolkitResource.new
  end

  it "must be valid" do
    @toolkit_resource.must_be :valid?
  end

  it "must be a real test" do
    skip "Need to write test for ToolkitResource"
    flunk "Need real tests"
  end
end
