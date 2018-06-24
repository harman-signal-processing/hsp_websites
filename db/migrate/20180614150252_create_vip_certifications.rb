class CreateVipCertifications < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_certifications do |t|
      t.string :name

      t.timestamps
    end
  end
end
