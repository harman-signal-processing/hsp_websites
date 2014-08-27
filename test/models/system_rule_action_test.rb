require "test_helper"

describe SystemRuleAction do
  let(:system_rule_action) { SystemRuleAction.new }

  it "must be valid" do
    system_rule_action.must_be :valid?
  end
end
