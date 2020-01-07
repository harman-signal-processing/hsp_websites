class CreateLocaleSoftwares < ActiveRecord::Migration[5.2]
  def change
    create_table :locale_softwares do |t|
      t.string :locale
      t.integer :software_id

      t.timestamps
    end
    add_index :locale_softwares, :software_id
  end
end
