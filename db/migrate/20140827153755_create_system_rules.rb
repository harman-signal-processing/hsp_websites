class CreateSystemRules < ActiveRecord::Migration
  def change
    create_table :system_rules do |t|
      t.integer :system_id

      t.timestamps
    end
    add_index :system_rules, :system_id
  end
end
