class AddHasUsSalesRepsToBrands < ActiveRecord::Migration
  def up
    add_column :brands, :has_us_sales_reps, :boolean
    add_column :brands, :us_sales_reps_from_brand_id, :integer

    dbx = Brand.find("dbx")
    bss = Brand.find("bss")

    bss.has_us_sales_reps = true
    bss.us_sales_reps_from_brand_id = dbx.id 
    bss.save
    
  end

  def down
  	remove_column :brands, :has_us_sales_reps
		remove_column :brands, :us_sales_reps_from_brand_id
  end
end
