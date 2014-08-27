require "test_helper"

describe SystemRule do
  let(:system_rule) { SystemRule.new }

  it "must be valid" do
    system_rule.must_be :valid?
  end
end
