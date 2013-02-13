class AddContactDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
    add_column :users, :job_description, :string
    add_column :users, :job_title, :string
    add_column :users, :profile_image_file_name, :string
    add_column :users, :profile_image_content_type, :string
    add_column :users, :profile_image_file_size, :integer
    add_column :users, :profile_image_updated_at, :datetime
  end
end
