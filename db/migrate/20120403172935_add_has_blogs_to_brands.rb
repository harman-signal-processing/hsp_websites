class AddHasBlogsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_blogs, :boolean

  end
end
