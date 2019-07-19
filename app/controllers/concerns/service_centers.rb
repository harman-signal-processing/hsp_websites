module ServiceCenters
	extend ActiveSupport::Concern
	
  def get_service_centers(brand, state)
    
    url = "https://pro.harman.com/service_centers/#{brand.downcase}/#{state.downcase}.json"
    encoded_url = URI.encode(url)
    
    response = HTTParty.get(encoded_url)
      if response.success?
        result = response.deep_symbolize_keys
      else
        raise response.message
      end
    
    result[:service_centers]    
  end	 #  def get_service_centers(brand, state)
	
end  #  module ServiceCenters