class CreateCustomizableAttributes < ActiveRecord::Migration[6.1]
  def change
    create_table :customizable_attributes do |t|
      t.string :name

      t.timestamps
    end
  end
end
