class AddHasLabelSheetsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_label_sheets, :boolean
    digitech = Brand.where(name: "DigiTech").first
    digitech.has_label_sheets = true
    digitech.save
  end
end
