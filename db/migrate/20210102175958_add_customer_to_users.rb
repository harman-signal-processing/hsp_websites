class AddCustomerToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :customer, :boolean
  end
end
