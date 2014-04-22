class AddDirectS3FieldsToSoftwares < ActiveRecord::Migration
  def change
    add_column :softwares, :direct_upload_url, :string
    add_column :softwares, :processed, :boolean, default: false
  end
end
