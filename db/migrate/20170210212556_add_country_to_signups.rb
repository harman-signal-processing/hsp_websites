class AddCountryToSignups < ActiveRecord::Migration
  def change
    add_column :signups, :country, :string
  end
end
