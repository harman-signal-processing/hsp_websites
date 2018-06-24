class CreateVipServiceServiceCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_service_service_categories do |t|
      t.integer :position
      t.references :vip_service, foreign_key: true
      t.references :vip_service_category, foreign_key: true

      t.timestamps
    end
  end
end
