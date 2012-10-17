class AddHasLabelSheetsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_label_sheets, :boolean
    digitech = Brand.find_by_name("DigiTech")
    digitech.has_label_sheets = true
    digitech.save
  end
end
