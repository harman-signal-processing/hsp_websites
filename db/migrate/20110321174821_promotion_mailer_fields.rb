class PromotionMailerFields < ActiveRecord::Migration
  def self.up
    add_column :promotions, :post_registration_subject, :string
    add_column :promotions, :post_registration_message, :text
    add_column :promotions, :send_post_registration_message, :boolean, :default => false
  end

  def self.down
    remove_column :promotions, :send_post_registration_message
    remove_column :promotions, :post_registration_message
    remove_column :promotions, :post_registration_subject
  end
end