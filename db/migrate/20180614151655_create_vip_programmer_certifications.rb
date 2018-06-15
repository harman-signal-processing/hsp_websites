class CreateVipProgrammerCertifications < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_programmer_certifications do |t|
      t.integer :position
      t.references :vip_programmer, foreign_key: true
      t.references :vip_certification, foreign_key: true

      t.timestamps
    end
  end
end
