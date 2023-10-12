class CreateBanners < ActiveRecord::Migration[7.0]
  def change
    create_table :banners do |t|
      t.string :name
      t.references :bannerable, polymorphic: true, null: false
      t.date :start_on
      t.date :remove_on

      t.timestamps
    end
  end
end
