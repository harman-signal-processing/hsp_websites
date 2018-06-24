class CreateVipTrainings < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_trainings do |t|
      t.string :name

      t.timestamps
    end
  end
end
