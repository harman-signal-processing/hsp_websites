class AddFeaturesTabNameToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :features_tab_name, :string
  end
end
