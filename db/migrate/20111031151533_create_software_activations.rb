class CreateSoftwareActivations < ActiveRecord::Migration
  def self.up
    create_table :software_activations do |t|
      t.integer :software_id
      t.string :challenge
      t.string :activation_key

      t.timestamps
    end
  end

  def self.down
    drop_table :software_activations
  end
end
