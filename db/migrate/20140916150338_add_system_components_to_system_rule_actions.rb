class AddSystemComponentsToSystemRuleActions < ActiveRecord::Migration
  def change
    add_column :system_rule_actions, :system_component_id, :integer
    add_column :system_rule_actions, :quantity, :integer
  end
end
