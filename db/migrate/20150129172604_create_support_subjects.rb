class CreateSupportSubjects < ActiveRecord::Migration
  def change
    create_table :support_subjects do |t|
      t.integer :brand_id
      t.string :name
      t.string :recipient
      t.integer :position

      t.timestamps
    end
    add_index :support_subjects, :brand_id
  end
end
