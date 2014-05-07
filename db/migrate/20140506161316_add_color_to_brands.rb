class AddColorToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :color, :string
  end
end
