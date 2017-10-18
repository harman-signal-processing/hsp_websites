class AddCountryToDownloadRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_column :download_registrations, :country, :string
  end
end
