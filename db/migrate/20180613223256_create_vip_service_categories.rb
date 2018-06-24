class CreateVipServiceCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_service_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
