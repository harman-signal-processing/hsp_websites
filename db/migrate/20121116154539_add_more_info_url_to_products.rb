class AddMoreInfoUrlToProducts < ActiveRecord::Migration
  def change
    add_column :products, :more_info_url, :string
  end
end
