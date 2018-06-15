class CreateVipSkills < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_skills do |t|
      t.string :name

      t.timestamps
    end
  end
end
