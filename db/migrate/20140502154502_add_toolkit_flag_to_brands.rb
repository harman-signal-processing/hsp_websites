class AddToolkitFlagToBrands < ActiveRecord::Migration
  def up
    add_column :brands, :toolkit, :boolean
    Brand.where(name: ["BSS", "dbx", "IDX", "Lexicon", "DigiTech", "DOD", "HiQnet"]).update_all(toolkit: true)
  end

  def down
  	remove_column :brands, :toolkit
  end
end
