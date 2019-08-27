class CountryList
  include HTTParty
  format :json
  
  def self.base_url
    ENV['PRO_SITE_URL']
  end  
  
  def self.countries
      url = "#{base_url}/location_info/countries.json"
    begin
      get_api_response(url, 8.hours)
    rescue
      []
    end
  end
  
  
  # :nocov:
  def self.get_api_response(url, cache_for)
    cache_for = 1.minute unless Rails.env.production?
    Rails.cache.fetch(url, expires_in: cache_for, race_condition_ttl: 10) do
      response = HTTParty.get(url, format: :plain)
      if response.success?
        data = JSON.parse response, symbolize_names: true
        countries = data[:locations]
        countries        
      else
        raise response.message
      end
    end
  end
  # :nocov:  
  
  
end  #  class CountryList