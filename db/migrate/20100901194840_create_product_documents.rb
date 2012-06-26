class CreateProductDocuments < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :product_documents, :options => options do |t|
      t.integer :product_id
      t.string :language
      t.string :document_type
      t.string :document_file_name
      t.integer :document_file_size
      t.datetime :document_updated_at
      t.string :document_content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :product_documents
  end
end
