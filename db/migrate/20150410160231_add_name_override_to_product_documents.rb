class AddNameOverrideToProductDocuments < ActiveRecord::Migration
  def change
    add_column :product_documents, :name_override, :string
  end
end
