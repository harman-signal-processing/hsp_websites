class AddMetaDescriptionToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :meta_description, :text
  end
end
