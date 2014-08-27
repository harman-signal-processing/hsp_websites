require "test_helper"

describe SystemRuleConditionGroup do
  let(:system_rule_condition_group) { SystemRuleConditionGroup.new }

  it "must be valid" do
    system_rule_condition_group.must_be :valid?
  end
end
