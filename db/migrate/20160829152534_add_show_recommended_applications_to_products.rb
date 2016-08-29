class AddShowRecommendedApplicationsToProducts < ActiveRecord::Migration
  def up
    add_column :products, :show_recommended_verticals, :boolean, default: true
    Product.update_all(show_recommended_verticals: true)
  end

  def down
    remove_column :products, :show_recommended_verticals
  end
end
