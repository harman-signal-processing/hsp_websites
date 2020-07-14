class AddTrainingToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :has_training, :boolean, :default => false
    Brand.all.each do |brand|
      brand.update({
        :has_training => !!(brand.name.match(/dbx|BSS/i))
      })
    end
  end

  def self.down
    remove_column :brands, :has_training
  end
end
