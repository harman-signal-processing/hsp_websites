class CreateVipProgrammers < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_programmers do |t|
      t.string :name
      t.text :description
      t.text :examples
      t.string :security_clearance

      t.timestamps
    end
  end
end
