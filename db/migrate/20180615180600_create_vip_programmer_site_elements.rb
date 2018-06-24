class CreateVipProgrammerSiteElements < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_programmer_site_elements do |t|
      t.references :vip_programmer, foreign_key: true
      t.bigint :site_element_id, foreign_key: { to_table: :site_element }

      t.timestamps
    end
  end
end
