class AddShowReviewQuotesToProductFamilies < ActiveRecord::Migration[6.0]
  def change
    add_column :product_families, :show_review_quotes, :boolean, default: true

    ProductFamily.update_all(show_review_quotes: true)
    ProductFamily.find("installed").update(show_review_quotes: false)
  end
end
