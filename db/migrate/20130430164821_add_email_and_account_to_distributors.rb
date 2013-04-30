class AddEmailAndAccountToDistributors < ActiveRecord::Migration
  def change
    add_column :distributors, :email, :string
    add_index :distributors, :email
    add_column :distributors, :account_number, :string
    add_index :distributors, :account_number
  end
end
