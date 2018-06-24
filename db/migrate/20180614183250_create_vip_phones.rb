class CreateVipPhones < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_phones do |t|
      t.string :label
      t.string :phone

      t.timestamps
    end
  end
end
