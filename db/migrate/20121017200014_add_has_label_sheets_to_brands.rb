class AddHasLabelSheetsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :has_label_sheets, :boolean
  end
end
