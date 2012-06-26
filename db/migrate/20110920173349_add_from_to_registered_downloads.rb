class AddFromToRegisteredDownloads < ActiveRecord::Migration
  def self.up
    add_column :registered_downloads, :from_email, :string
    add_column :registered_downloads, :subject, :string
  end

  def self.down
    remove_column :registered_downloads, :subject
    remove_column :registered_downloads, :from_email
  end
end