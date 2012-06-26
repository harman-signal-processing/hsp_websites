class AddDemoLinkToProducts < ActiveRecord::Migration
  def change
    add_column :products, :demo_link, :string
  end
end
