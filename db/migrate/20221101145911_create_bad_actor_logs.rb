class CreateBadActorLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :bad_actor_logs do |t|
      t.string :ip_address
      t.string :reason
      t.text :details

      t.timestamps
    end
    add_index :bad_actor_logs, :ip_address
  end
end
