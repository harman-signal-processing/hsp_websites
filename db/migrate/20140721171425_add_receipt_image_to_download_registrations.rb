class AddReceiptImageToDownloadRegistrations < ActiveRecord::Migration
  def change
    add_column :download_registrations, :receipt_file_name, :string
    add_column :download_registrations, :receipt_file_size, :integer
    add_column :download_registrations, :receipt_content_type, :string
    add_column :download_registrations, :receipt_updated_at, :datetime
  end
end
