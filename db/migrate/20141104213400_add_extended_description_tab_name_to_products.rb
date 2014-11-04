class AddExtendedDescriptionTabNameToProducts < ActiveRecord::Migration
  def change
    add_column :products, :extended_description_tab_name, :string
  end
end
