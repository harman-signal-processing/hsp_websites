# include HTTParty

module MartinFirmwareService
   def self.get_firmware_data
    url = "#{ENV['MARTIN_FIRMWARE_URL']}"
    response = HTTParty.get(url)
    if response.success?
      result = JSON.parse(response).deep_symbolize_keys
    else
      raise response.message
    end
      
     result[:firmwarefiles]    
   end  #  def self.get_firmware_data
   
   def self.get_firmware_items
    firmware_items = {}
    MartinFirmwareService.get_firmware_data.each do |item| 
        # name = item[0].to_s
        value = item[1].to_s
        value_split_on_forward_slash = value.split("/")
        category = "#{value_split_on_forward_slash[1]} Range"
        product = "#{value_split_on_forward_slash[2]}"
        version = "#{value_split_on_forward_slash[3]}".split("|")[0]
        
        if firmware_items[category.to_sym].present?
            firmware_items[category.to_sym][:items] << { product: product, version: version }
        else
            firmware_items[category.to_sym] = { items: [] }
            firmware_items[category.to_sym][:items] << { product: product, version: version }
        end
     end     
     firmware_items
   end  #  self.get_firmware_items
 
   def self.firmware_items_from_cache
      cache_for = Rails.env.production? ? 1.hour : 1.minute
      Rails.cache.fetch("martin_firmware", expires_in: cache_for, race_condition_ttl: 10) do
          self.get_firmware_items
      end  #  Rails.cache.fetch("martin_firmware", expires_in: cache_for, race_condition_ttl: 10) do     
   end
   
   def self.firmware_version(product_name)
       version = ""
       
       firmware_item_group_for_product = MartinFirmwareService.firmware_items_from_cache.select{|key, value| 
          value[:items].select{|item| item[:product] == product_name }.count > 0
       }  #  MartinFirmwareService.firmware_items_from_cache.select{|key, value|
       
       begin
           firmware_items = firmware_item_group_for_product[firmware_item_group_for_product.keys[0]][:items]
           firmware_items_for_product = firmware_items.select{|p| p[:product] == product_name}
           
           latest_firmware_for_product = latest_product_version_item(firmware_items_for_product)
           version = latest_firmware_for_product[:version]
       rescue => e
       end
      version
   end  #  def self.firmware_version(product_name)
 
   def self.latest_product_version_item(product_version_items)
     if product_version_items.count > 1
       # When there are multiple versions for the same product, show the latest version only
       begin
           highest_version_item = product_version_items.sort_by { |item| 
               # Keep only digits and periods in the version number for sorting purposes, also strip any trailing periods
               clean_version = item[:version].delete('^0-9.').gsub(/\.+$/, '')
               Gem::Version.new(clean_version) 
           }.reverse!.take(1) 
       rescue => e
       end
       item_to_return = { product: highest_version_item[0][:product], version: highest_version_item[0][:version] }
     else
       item_to_return = { product: product_version_items[0][:product], version: product_version_items[0][:version] }
     end
     
     item_to_return
   end  #  def self.latest_product_version_item(item)
 
 end  #  module MartinFirmwareService