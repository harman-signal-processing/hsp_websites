class CreateContactMessages < ActiveRecord::Migration
  def self.up
    options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :contact_messages, :options => options do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_messages
  end
end
