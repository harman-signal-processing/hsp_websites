class CreateRsoSettings < ActiveRecord::Migration
  def self.up
    create_table :rso_settings do |t|
      t.string :name
      t.string :setting_type, :default => "string"
      t.string :string_value
      t.integer :integer_value
      t.text :text_value
      t.text :html_value

      t.timestamps
    end
    RsoSetting.create!(:name => "invitation_code", :string_value => "HSP-RSO")
  end

  def self.down
    drop_table :rso_settings
  end
end
