class CreateVipProgrammerPhones < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_programmer_phones do |t|
      t.integer :position
      t.references :vip_programmer, foreign_key: true
      t.references :vip_phone, foreign_key: true

      t.timestamps
    end
  end
end
