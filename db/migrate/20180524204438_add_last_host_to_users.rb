class AddLastHostToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_host, :string
  end
end
