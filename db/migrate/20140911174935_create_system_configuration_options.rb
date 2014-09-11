class CreateSystemConfigurationOptions < ActiveRecord::Migration
  def change
    create_table :system_configuration_options do |t|
      t.integer :system_configuration_id
      t.integer :system_option_id
      t.integer :system_option_value_id
      t.string :direct_value

      t.timestamps
    end
    add_index :system_configuration_options, :system_configuration_id
  end
end
