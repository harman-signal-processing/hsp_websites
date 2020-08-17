class CreateAmxItgNewModuleRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :amx_itg_new_module_requests do |t|
      t.string :device_type
      t.string :manufacturer
      t.text :models
      t.string :method_of_control
      t.attachment :attachment
      t.text :additional_notes
      
      t.string :project_type
      t.text :other_project_type
      t.string :num_systems
      t.string :amx_controller_types
      t.text :other_amx_controller_type
      t.string :num_devices_using_module
      t.date :expected_installation_date
      
      t.string :requestor
      t.string :region
      t.string :company
      t.string :phone
      t.string :email
      t.string :harman_account_manager
      t.text :additional_info
      
      t.boolean :agree_to_validate_onsite
      t.boolean :agree_device_has_api_feeback
      t.boolean :agree_to_recieve_emails
      
      t.string :contact_name
      t.string :contact_email
      
      t.string :direct_upload_url
      t.boolean :processed, default: false      
      
      t.timestamps
    end
  end
end
