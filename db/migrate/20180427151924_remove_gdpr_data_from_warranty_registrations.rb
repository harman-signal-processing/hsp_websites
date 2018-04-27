class RemoveGdprDataFromWarrantyRegistrations < ActiveRecord::Migration[5.1]
  def up
    remove_column :warranty_registrations, :address1
    remove_column :warranty_registrations, :city
    remove_column :warranty_registrations, :state
    remove_column :warranty_registrations, :zip
    remove_column :warranty_registrations, :phone
    remove_column :warranty_registrations, :fax
    remove_column :warranty_registrations, :age
    remove_column :warranty_registrations, :marketing_question1
    remove_column :warranty_registrations, :marketing_question2
    remove_column :warranty_registrations, :marketing_question3
    remove_column :warranty_registrations, :marketing_question4
    remove_column :warranty_registrations, :marketing_question5
    remove_column :warranty_registrations, :marketing_question6
    remove_column :warranty_registrations, :marketing_question7
  end

  def down
    add_column :warranty_registrations, :address1, :string
    add_column :warranty_registrations, :city, :string
    add_column :warranty_registrations, :state, :string
    add_column :warranty_registrations, :zip, :string
    add_column :warranty_registrations, :phone, :string
    add_column :warranty_registrations, :fax, :string
    add_column :warranty_registrations, :age, :string
    add_column :warranty_registrations, :marketing_question1, :string
    add_column :warranty_registrations, :marketing_question2, :string
    add_column :warranty_registrations, :marketing_question3, :string
    add_column :warranty_registrations, :marketing_question4, :string
    add_column :warranty_registrations, :marketing_question5, :string
    add_column :warranty_registrations, :marketing_question6, :string
    add_column :warranty_registrations, :marketing_question7, :string
  end
end
