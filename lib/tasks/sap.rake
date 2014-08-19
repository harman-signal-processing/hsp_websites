require 'nokogiri'

namespace :sap do

	desc "Import latest pricing from SAP"
	task import_pricing: :environment do
		items = parse_items(ENV['PRICING_FILE'], 'price-item')
		# puts items.to_yaml
		items.each do |item|
			if product = find_matching_product(item[:sku])
				product.msrp_cents = (item['list-price'].to_f * 100).to_i
				product.cost_cents = (item['cost-price'].to_f * 100).to_i
				# Skipping 'sale-price' for now. Not sure what SAP is giving me here.
				# product.sale_price = (item['sale-price'].to_f * 100).to_i
				product.set_employee_price
				product.save if product.changed?
				# puts product.to_yaml	
			end
		end
	end

	desc "Import latest inventory levels from SAP"
	task import_inventory: :environment do
		items = parse_items(ENV['INVENTORY_FILE'], 'inventory-item')
		# puts items.to_yaml
		items.each do |item|
			if product = find_matching_product(item[:sku])
				product.stock_status = item['inventory-status'].to_s
				d = item['availability-date'].split(/\//)
				available_on = [d[2], d[0], d[1]].join('-')
				product.available_on = available_on.to_date
				product.stock_level  = item['stock-level'].to_i
				product.save if product.changed?
				puts product.to_yaml
			end
		end
	end

	def parse_items(xml_file, node_name)
		items = []
		Nokogiri::XML(open(xml_file)).search("*//#{node_name}").each do |pi|
			item = { sku: pi[:id] }
			pi.elements.each {|el| item[el.name] = trim_content(el.content) }
			items << item
		end
		items
	end

	def trim_content(content)
		content.to_s.gsub(/\r|\n|\r\n/, '').gsub(/^\s*/, '').gsub(/\s*$/, '')
	end

	# Try to use intelligence to find SKUs which may or may not have
	# -V or -M appended.
	#
	# TODO: But what about if the XML file has all of these skus? Then the
	# -V or -M is probably a newer SKU with better info. How do we guarantee
	# we don't update the Product with old info?
	#
	def find_matching_product(sku)
		variants = [sku, sku.gsub(/\-?V/i, ''), sku.gsub(/\-?M/i, '')]
		puts "Variants: #{variants}"
		Product.where(sap_sku: variants).first
	end
end