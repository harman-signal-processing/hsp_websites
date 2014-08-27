class CreateSystemRuleConditions < ActiveRecord::Migration
  def change
    create_table :system_rule_conditions do |t|
      t.integer :system_rule_condition_group_id
      t.integer :system_option_id
      t.string :operator
      t.integer :system_option_value_id
      t.string :direct_value
      t.string :logic_type

      t.timestamps
    end
    add_index :system_rule_conditions, :system_rule_condition_group_id
  end
end
