class AddProductTreesToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :product_trees, :boolean
    if dig = Brand.find("digitech")
    	dig.product_trees = true
    	dig.save
    end
    if bss = Brand.find("bss")
    	bss.product_trees = true
    	bss.save
    end
  end
end
