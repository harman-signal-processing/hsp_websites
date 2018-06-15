class CreateVipEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_emails do |t|
      t.string :label
      t.string :email

      t.timestamps
    end
  end
end
