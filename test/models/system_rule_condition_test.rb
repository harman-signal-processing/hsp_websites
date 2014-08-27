require "test_helper"

describe SystemRuleCondition do
  let(:system_rule_condition) { SystemRuleCondition.new }

  it "must be valid" do
    system_rule_condition.must_be :valid?
  end
end
