class AddHarmanOwnedToBrands < ActiveRecord::Migration[7.0]
  def change
    add_column :brands, :harman_owned, :boolean, default: true

    Brand.update_all(harman_owned: true)
    Brand.find("studer").update(harman_owned: false)
    Brand.find("digitech").update(harman_owned: false)
    Brand.find("dod").update(harman_owned: false)
    Brand.find("hardwire").update(harman_owned: false)
    Brand.find("vocalist").update(harman_owned: false)
  end
end
