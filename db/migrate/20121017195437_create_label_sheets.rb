class CreateLabelSheets < ActiveRecord::Migration
  def change
    create_table :label_sheets do |t|
      t.string :name
      t.text :products

      t.timestamps
    end

  end
end
