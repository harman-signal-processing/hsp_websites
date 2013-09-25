class AddQueueToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :queue, :boolean
  end
end
