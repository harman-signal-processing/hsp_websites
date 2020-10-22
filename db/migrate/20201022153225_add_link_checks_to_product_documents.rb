class AddLinkChecksToProductDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :product_documents, :link_checked_at, :datetime
    add_column :product_documents, :link_status, :string
  end
end
