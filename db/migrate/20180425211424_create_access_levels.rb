class CreateAccessLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :access_levels do |t|
      t.string :name
      t.boolean :distributor
      t.boolean :dealer
      t.boolean :technician

      t.timestamps
    end

    AccessLevel.where(
      name: "100",
      distributor: true,
      dealer: true
    ).first_or_create

    AccessLevel.where(
      name: "200",
      technician: true
    ).first_or_create
  end
end
