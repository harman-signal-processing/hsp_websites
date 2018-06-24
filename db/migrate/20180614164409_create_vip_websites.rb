class CreateVipWebsites < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_websites do |t|
      t.string :url

      t.timestamps
    end
  end
end
