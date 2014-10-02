class AddPerformOppositeToSystemRules < ActiveRecord::Migration
  def change
    add_column :system_rules, :perform_opposite, :boolean, default: true
  end
end
