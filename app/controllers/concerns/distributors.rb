module Distributors
	extend ActiveSupport::Concern
	
  def get_international_distributors(brand, country_code)
    
    url = "https://pro.harman.com/distributor_info/distributors/#{brand}/#{country_code}.json"
    
    response = HTTParty.get(url)
      if response.success?
        result = response.deep_symbolize_keys
      else
        raise response.message
      end
    
    result[:distributors]    
  end	 # def get_international_distributors(brand, country_code)
end  #  module Distributors