class CreateTrainingClassRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :training_class_registrations do |t|
      t.integer :training_class_id
      t.string :name
      t.string :email
      t.text :comments

      t.timestamps
    end
    add_index :training_class_registrations, :training_class_id
  end
end
