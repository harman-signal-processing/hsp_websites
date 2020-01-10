class AddRegistrationLinkToTrainingClasses < ActiveRecord::Migration[5.2]
  def change
    add_column :training_classes, :registration_url, :string
  end
end
