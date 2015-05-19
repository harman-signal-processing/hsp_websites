class CreateSystemConfigurationOptionValues < ActiveRecord::Migration
  def change
    create_table :system_configuration_option_values do |t|
      t.integer :system_configuration_option_id
      t.integer :system_option_value_id

      t.timestamps null: false
    end
    add_index :system_configuration_option_values, :system_configuration_option_id, name: 's_c_o_v_s_c_o_id'
  end
end
