class RemoveShowReviewsFromProductFamilies < ActiveRecord::Migration[6.0]
  def change
    remove_column :product_families, :show_review_quotes, :boolean, default: true
  end
end
