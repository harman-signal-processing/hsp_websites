require 'nokogiri'

namespace :sap do

	desc "Import latest pricing from SAP"
	task import_pricing: :environment do
		items = parse_items(ENV['PRICING_FILE'], 'price-item')
		# puts items.to_yaml

		problem_products = []
		Product.where("sap_sku IS NOT NULL AND sap_sku != ''").each do |product|
			if item = find_item_by_product(product, items)
				# puts "SKU found for #{product.name}"
				product.msrp_cents = (item['list-price'].to_f * 100).to_i
				product.cost_cents = (item['cost-price'].to_f * 100).to_i
				# Skipping 'sale-price' for now. Not sure what SAP is giving me here.
				# product.sale_price = (item['sale-price'].to_f * 100).to_i
				product.set_employee_price
				if product.changed?
				    puts "Updating #{product.name}: MSRP=#{product.msrp_cents}, COST=#{product.cost_cents}, HARMAN=#{product.harman_employee_price_cents}"
				    product.save
				end
			else
				problem_products << product unless product.discontinued?
			end
		end

		if problem_products.length > 0
            puts "Could not find matching items in the PRICING XML file for the following: "
            problem_products.each{|p| puts "#{p.name} (#{p.sap_sku})"}
   		end
	end

	desc "Import latest inventory levels from SAP"
	task import_inventory: :environment do
		items = parse_items(ENV['INVENTORY_FILE'], 'inventory-item')
		# puts items.to_yaml

		problem_products = []
		Product.where("sap_sku IS NOT NULL AND sap_sku != ''").each do |product|
			if item = find_item_by_product(product, items)
				product.stock_status = item['inventory-status'].to_s
				begin
					product.available_on = Date.strptime(item['availability-date'], '%m/%d/%Y')
				rescue ArgumentError
				end
				product.stock_level = item['stock-level'].to_i
				if product.changed?
					puts "Updating #{product.name}: STOCK=#{product.stock_status}, AVAIL=#{product.available_on},	STOCK_LEVEL=#{product.stock_level}"
					product.save
				end
			else
				problem_products << product unless product.discontinued?
			end
		end

		if problem_products.length > 0
            puts "Could not find matching items in the INVENTORY XML file for the following: "
            problem_products.each{|p| puts "#{p.name} (#{p.sap_sku})"}
		end
	end

	def parse_items(xml_file, node_name)
		items = {}
		Nokogiri::XML(open(xml_file, 'r')).search("*//#{node_name}").each do |pi|
			item = {}
			pi.elements.each do |el| 
				item[el.name] = trim_content(el.content)
			end
			items[pi[:id]] = item
		end
		items
	end

	def trim_content(content)
		content.to_s.gsub(/\r|\n|\r\n/, '').gsub(/^\s*/, '').gsub(/\s*$/, '')
	end

	# Try to use intelligence to find SKUs which may or may not have
	# -V or -M appended.
	#
	def find_item_by_product(product, items)
		sku = product.sap_sku.to_s.upcase
		sku_options = sku.match(/\-?[MV]$/) ? [sku, sku.gsub(/\-?[MV]$/, '')] : sku_options = ["#{sku}-V", "#{sku}-M", "#{sku}V", "#{sku}M", sku]

		item = nil
		sku_options.each do |s|
			if item = items[s]
				return item
			end
		end
		item
	end
end