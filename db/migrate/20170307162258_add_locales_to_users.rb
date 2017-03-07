class AddLocalesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :locales, :string
  end
end
