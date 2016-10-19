class CreateGetStartedPanels < ActiveRecord::Migration
  def change
    create_table :get_started_panels do |t|
      t.integer :get_started_page_id
      t.integer :position
      t.boolean :locked_until_registration, default: true
      t.string :name
      t.text :content

      t.timestamps null: false
    end
  end
end
