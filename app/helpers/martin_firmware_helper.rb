module MartinFirmwareHelper
  def latest_product_version_item(product_version_item)
      
      if product_version_item[1].count > 1
        # When there are multiple versions for the same product, show the latest version only
        begin
            highest_version_item = product_version_item[1].sort_by { |item| 
                # Keep only digits and periods in the version number for sorting purposes, also strip any trailing periods
                clean_version = item[:version].delete('^0-9.').gsub(/\.+$/, '')
                Gem::Version.new(clean_version) 
            }.reverse!.take(1) 
        rescue => e
        end
        item_to_return = { product: highest_version_item[0][:product], version: highest_version_item[0][:version] }
      else
        item_to_return = { product: product_version_item[1][0][:product], version: product_version_item[1][0][:version] }
      end
      
      item_to_return
  end  #  def latest_product_version_item(item)
end  #  module MartinFirmwareHelper