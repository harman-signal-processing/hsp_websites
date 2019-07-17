module Rsos
	extend ActiveSupport::Concern
	
  def get_rsos(country_code)
    
    url = "https://pro.harman.com/contact_info/rso/#{country_code}.json"
    encoded_url = URI.encode(url)
    
    response = HTTParty.get(encoded_url)
      if response.success?
        result = response.deep_symbolize_keys
      else
        raise response.message
      end
    
    result[:rsos]    
  end	 # def get_rsos(country_code)
end  #  module Rsos