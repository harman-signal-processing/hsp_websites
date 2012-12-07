class CreateSoftwareOperatingSystems < ActiveRecord::Migration
  def change
    create_table :software_operating_systems do |t|
      t.integer :software_id
      t.integer :operating_system_id

      t.timestamps
    end
    add_index :software_operating_systems, :software_id
    add_index :software_operating_systems, :operating_system_id
  end
end
