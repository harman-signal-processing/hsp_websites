class AddCollapseContentToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :collapse_content, :boolean, default: false
    add_column :brands, :collapse_content, :boolean, default: false
  end
end
