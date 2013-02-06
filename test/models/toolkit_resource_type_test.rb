require "minitest_helper"

describe ToolkitResourceType do
  # fixtures :all

  before do
    @toolkit_resource_type = ToolkitResourceType.new
  end

  it "must be valid" do
    @toolkit_resource_type.must_be :valid?
  end

  it "must be a real test" do
    skip "Need to write test for ToolkitResourceType"
    flunk "Need real tests"
  end
end
