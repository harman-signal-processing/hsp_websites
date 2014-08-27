class CreateSystemRuleActions < ActiveRecord::Migration
  def change
    create_table :system_rule_actions do |t|
      t.integer :system_rule_id
      t.string :action_type
      t.integer :system_option_id
      t.integer :system_option_value_id
      t.text :alert

      t.timestamps
    end
    add_index :system_rule_actions, :system_rule_id
  end
end
