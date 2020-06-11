class AddShowOnPublicSiteToProductDocuments < ActiveRecord::Migration[5.2]
  def change
  	add_column :product_documents, :show_on_public_site, :boolean, default: true
  end
end
