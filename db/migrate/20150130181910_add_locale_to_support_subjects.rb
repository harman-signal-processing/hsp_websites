class AddLocaleToSupportSubjects < ActiveRecord::Migration
  def change
    add_column :support_subjects, :locale, :string
    add_index :support_subjects, :locale
  end
end
