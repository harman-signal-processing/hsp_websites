class ThunderstoneSearch
  include HTTParty
  format :json

  def self.find(query, profile, jump)
    url = "#{base_url}query=#{query}&profile=#{profile}&jump=#{jump}"
    begin
      get_api_response(url)
    rescue
      {}
    end
  end

  private

  def self.base_url
    ENV['THUNDERSTONE_SEARCH_PROXY_URL']
  end

  # :nocov:
  def self.get_api_response(url)
      #escaping url to handle non english search terms
      escapedUrl = Addressable::URI.parse(url).normalize
      response = HTTParty.get(escapedUrl, format: :plain)
      if response.success?
        JSON.parse response, symbolize_names: true
      else
        raise response.message
      end    
  end
  # :nocov:

end
