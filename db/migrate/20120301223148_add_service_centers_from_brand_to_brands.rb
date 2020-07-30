class AddServiceCentersFromBrandToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :service_centers_from_brand_id, :integer
    Brand.all.each do |brand|
      unless brand.dealers_from_brand_id.blank?
        brand.update(:service_centers_from_brand_id => brand.dealers_from_brand_id)
      end
    end
    lex = Brand.find("lexicon")
    dbx = Brand.find("dbx")
    lex.update(:service_centers_from_brand_id => dbx.id)
  end
end
