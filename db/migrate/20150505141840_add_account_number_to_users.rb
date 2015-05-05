class AddAccountNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_number, :string
    add_index :users, :account_number
  end
end
