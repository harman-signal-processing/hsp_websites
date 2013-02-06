class CreateToolkitResourceTypes < ActiveRecord::Migration
  def change
    create_table :toolkit_resource_types do |t|
      t.string :name
      t.integer :position
      t.string :related_model
      t.string :related_attribute

      t.timestamps
    end
  end
end
