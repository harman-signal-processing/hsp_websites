class AddRatioToSystemRuleActions < ActiveRecord::Migration
  def change
    add_column :system_rule_actions, :ratio, :string
  end
end
