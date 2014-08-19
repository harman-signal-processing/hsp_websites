class AddInventoryToProducts < ActiveRecord::Migration
  def change
    rename_column :products, :harman_employee_price, :temp_harman_employee_price
    rename_column :products, :street_price, :temp_street_price
    rename_column :products, :msrp, :temp_msrp
    rename_column :products, :sale_price, :temp_sale_price

    add_column :products, :stock_status, :string
    add_column :products, :available_on, :date
    add_column :products, :stock_level, :integer
    add_money :products, :harman_employee_price, amount: { null: true, default: nil}
    add_money :products, :street_price, amount: { null: true, default: nil}
    add_money :products, :msrp, amount: { null: true, default: nil}
    add_money :products, :sale_price, amount: { null: true, default: nil}
    add_money :products, :cost, amount: { null: true, default: nil}

    Product.all.each do |product|
    	if product.temp_harman_employee_price.present?
    		product.harman_employee_price_cents = (product.temp_harman_employee_price.to_f * 100).to_i
    	end
    	if product.temp_street_price.present?
    		product.street_price_cents = (product.temp_street_price.to_f * 100).to_i
    	end
    	if product.temp_sale_price.present?
    		product.sale_price_cents = (product.temp_sale_price.to_f * 100).to_i
    	end
    	if product.temp_msrp.present?
    		product.msrp_cents = (product.temp_msrp.to_f * 100).to_i
    	end
    	if product.changed?
    		product.save!
    	end
    end

    # These are now replaced with the "_cents" for each price type 
    remove_column :products, :temp_harman_employee_price
    remove_column :products, :temp_street_price
    remove_column :products, :temp_sale_price
    remove_column :products, :temp_msrp
  end
end
