class AddShippingCountryToContactMessages < ActiveRecord::Migration
  def change
    add_column :contact_messages, :shipping_country, :string
  end
end
