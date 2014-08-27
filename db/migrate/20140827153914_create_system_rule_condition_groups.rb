class CreateSystemRuleConditionGroups < ActiveRecord::Migration
  def change
    create_table :system_rule_condition_groups do |t|
      t.integer :system_rule_id
      t.string :logic_type

      t.timestamps
    end
    add_index :system_rule_condition_groups, :system_rule_id
  end
end
