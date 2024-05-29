class AddCustomCssToFeatures < ActiveRecord::Migration[7.1]
  def change
    add_column :features, :custom_css, :text
  end
end
