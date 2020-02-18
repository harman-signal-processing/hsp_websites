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
 
end  #  module MartinFirmwareService