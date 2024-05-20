class AddCustomCssToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :custom_css, :text
  end
end
