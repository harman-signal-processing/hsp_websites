class CreateVipProgrammerTrainings < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_programmer_trainings do |t|
      t.integer :position
      t.references :vip_programmer, foreign_key: true
      t.references :vip_training, foreign_key: true

      t.timestamps
    end
  end
end
