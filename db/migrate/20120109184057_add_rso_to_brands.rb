class AddRsoToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :rso_enabled, :boolean
    Brand.find_by_name("BSS").update_attributes(:rso_enabled => true)
    Brand.find_by_name("dbx").update_attributes(:rso_enabled => true)
    Brand.find_by_name("Lexicon").update_attributes(:rso_enabled => true)
    Brand.find_by_name("JBL Commercial").update_attributes(:rso_enabled => true)
    Brand.find_by_name("DigiTech").update_attributes(:rso_enabled => true)
  end

  def self.down
    remove_column :brands, :rso_enabled
  end
end
