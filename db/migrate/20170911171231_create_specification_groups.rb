class CreateSpecificationGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :specification_groups do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
