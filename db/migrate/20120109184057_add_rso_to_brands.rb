class AddRsoToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :rso_enabled, :boolean
    Brand.where(name: "BSS").first.update(:rso_enabled => true)
    Brand.where(name: "dbx").first.update(:rso_enabled => true)
    Brand.where(name: "Lexicon").first.update(:rso_enabled => true)
    Brand.where(name: "JBL Commercial").first.update(:rso_enabled => true)
    Brand.where(name: "DigiTech").first.update(:rso_enabled => true)
  end

  def self.down
    remove_column :brands, :rso_enabled
  end
end
