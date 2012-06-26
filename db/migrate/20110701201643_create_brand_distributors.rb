class CreateBrandDistributors < ActiveRecord::Migration
  def self.up
    create_table :brand_distributors do |t|
      t.integer :distributor_id
      t.integer :brand_id

      t.timestamps
    end
    Distributor.all.each do |d|
      BrandDistributor.create(:brand_id => BRAND_ID, :distributor_id => d.id)
    end
  end

  def self.down
    drop_table :brand_distributors
  end
end
