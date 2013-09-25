class CreateMarketingComments < ActiveRecord::Migration
  def change
    create_table :marketing_comments do |t|
      t.integer :marketing_project_id
      t.integer :user_id
      t.text :message

      t.timestamps
    end
    add_index :marketing_comments, :marketing_project_id
  end
end
