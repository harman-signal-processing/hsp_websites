class AddSquareImageToNews < ActiveRecord::Migration[7.0]
  def change
    add_column :news, :square_file_name, :string
    add_column :news, :square_content_type, :string
    add_column :news, :square_file_size, :integer
    add_column :news, :square_updated_at, :datetime
  end
end
