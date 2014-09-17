class CreateSystemConfigurationComponents < ActiveRecord::Migration
  def change
    create_table :system_configuration_components do |t|
      t.integer :system_configuration_id
      t.integer :system_component_id
      t.integer :quantity

      t.timestamps
    end
    add_index :system_configuration_components, :system_configuration_id
  end
end
