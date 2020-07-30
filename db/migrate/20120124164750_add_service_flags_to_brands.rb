class AddServiceFlagsToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :has_parts_form, :boolean
    add_column :brands, :has_rma_form, :boolean
    Brand.all.each do |brand|
      brand.update({
        :has_parts_form => !!(brand.name.match(/dbx/)),
        :has_rma_form => !!(brand.name.match(/dbx/))
      })
    end
  end

  def self.down
    remove_column :brands, :has_rma_form
    remove_column :brands, :has_parts_form
  end
end
