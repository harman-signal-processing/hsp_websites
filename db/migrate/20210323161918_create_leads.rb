class CreateLeads < ActiveRecord::Migration[6.1]
  def change
    create_table :leads do |t|
      t.string :name
      t.string :company
      t.string :email
      t.string :phone
      t.text :project_description
      t.string :source
      t.string :city
      t.string :state
      t.string :country
      t.boolean :subscribe, default: false

      t.timestamps
    end
  end
end
