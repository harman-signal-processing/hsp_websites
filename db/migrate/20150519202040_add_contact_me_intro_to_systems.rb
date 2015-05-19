class AddContactMeIntroToSystems < ActiveRecord::Migration
  def change
    add_column :systems, :contact_me_intro, :text
  end
end
