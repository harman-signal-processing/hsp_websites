class AddRmaFieldsToContactMessages < ActiveRecord::Migration
  def self.up
    add_column :contact_messages, :message_type, :string
    add_column :contact_messages, :company, :string
    add_column :contact_messages, :account_number, :string
    add_column :contact_messages, :phone, :string
    add_column :contact_messages, :fax, :string
    add_column :contact_messages, :billing_address, :string
    add_column :contact_messages, :billing_city, :string
    add_column :contact_messages, :billing_state, :string
    add_column :contact_messages, :billing_zip, :string
    add_column :contact_messages, :shipping_address, :string
    add_column :contact_messages, :shipping_city, :string
    add_column :contact_messages, :shipping_state, :string
    add_column :contact_messages, :shipping_zip, :string
    add_column :contact_messages, :product_sku, :string
    add_column :contact_messages, :product_serial_number, :string
    add_column :contact_messages, :warranty, :boolean
    add_column :contact_messages, :purchased_on, :date
    add_column :contact_messages, :part_number, :string
    add_column :contact_messages, :board_location, :string
  end

  def self.down
    remove_column :contact_messages, :board_location
    remove_column :contact_messages, :part_number
    remove_column :contact_messages, :purchased_on
    remove_column :contact_messages, :warranty
    remove_column :contact_messages, :product_serial_number
    remove_column :contact_messages, :product_sku
    remove_column :contact_messages, :shipping_zip
    remove_column :contact_messages, :shipping_state
    remove_column :contact_messages, :shipping_city
    remove_column :contact_messages, :shipping_address
    remove_column :contact_messages, :billing_zip
    remove_column :contact_messages, :billing_state
    remove_column :contact_messages, :billing_city
    remove_column :contact_messages, :billing_address
    remove_column :contact_messages, :fax
    remove_column :contact_messages, :phone
    remove_column :contact_messages, :account_number
    remove_column :contact_messages, :company
    remove_column :contact_messages, :message_type
  end
end
