class AddBannerIdToPromotions < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :banner_id, :integer
  end
end
