# include HTTParty

module MartinFirmwareService
 def self.get_firmware_data
    url = "#{ENV['MARTIN_FIRMWARE_URL']}"
    response = HTTParty.get(url)
    if response.success?
    #   result = response.deep_symbolize_keys
      result = JSON.parse(response).deep_symbolize_keys
    
    else
      raise response.message
    end
      
     binding.pry
     result[:distributors]    
 end
end  #  module MartinFirmware