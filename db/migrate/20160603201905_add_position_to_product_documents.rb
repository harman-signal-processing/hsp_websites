class AddPositionToProductDocuments < ActiveRecord::Migration
  def change
    add_column :product_documents, :position, :integer
  end
end
