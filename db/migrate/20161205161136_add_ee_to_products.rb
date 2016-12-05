class AddEeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :enterprise, :boolean, default: false
    add_column :products, :entertainment, :boolean, default: false
  end
end
