class AddTreeToParts < ActiveRecord::Migration[5.1]
  def change
    add_column :parts, :parent_id, :integer
    add_index :parts, :parent_id
  end
end
