class AddEnabledToSystemRules < ActiveRecord::Migration
  def change
    add_column :system_rules, :enabled, :boolean, default: true
  end
end
