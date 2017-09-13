class AddGroupToSpecifications < ActiveRecord::Migration[5.1]
  def change
    add_column :specifications, :specification_group_id, :integer
    add_index :specifications, :specification_group_id
    add_column :specifications, :position, :integer
  end
end
