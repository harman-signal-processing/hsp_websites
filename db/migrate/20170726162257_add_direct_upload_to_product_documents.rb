class AddDirectUploadToProductDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :product_documents, :direct_upload_url, :string
    add_column :product_documents, :processed, :boolean, default: false
  end
end
