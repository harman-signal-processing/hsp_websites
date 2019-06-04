module ServiceCenters
	extend ActiveSupport::Concern
	
  def get_service_centers(brand, state)
    
    url = "https://pro.harman.com/service_centers/#{brand}/#{state.downcase}.json"
    
    response = HTTParty.get(url)
      if response.success?
        result = response.deep_symbolize_keys
      else
        raise response.message
      end
    
    result[:service_centers]    
  end	 #  def get_service_centers(brand, state)
	
end  #  module ServiceCenters