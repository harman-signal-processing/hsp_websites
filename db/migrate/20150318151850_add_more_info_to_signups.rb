class AddMoreInfoToSignups < ActiveRecord::Migration
  def change
    add_column :signups, :first_name, :string
    add_column :signups, :last_name, :string
    add_column :signups, :company, :string
    add_column :signups, :address, :string
    add_column :signups, :city, :string
    add_column :signups, :state, :string
    add_column :signups, :zip, :string
  end
end
