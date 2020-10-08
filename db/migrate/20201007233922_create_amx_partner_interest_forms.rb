class CreateAmxPartnerInterestForms < ActiveRecord::Migration[6.0]
  def change
    create_table :amx_partner_interest_forms do |t|
      t.string :company_name
      t.string :company_url
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :street_address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :product_target_market_segment
      t.string :partnership_interest
      t.text :additional_comments

      t.timestamps
    end
  end
end
