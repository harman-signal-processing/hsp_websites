class SolutionMarket
  include HTTParty

  format :json

  def self.all
    get_api_response(base_url, 8.hours)
  end

  def self.find(id)
    url = base_url + "/#{id}"
    get_api_response(url, 8.hours)
  end

  private

  def self.base_url
    "http://pro.harman.com/applications"
  end

  # :nocov:
  def self.get_api_response(url, cache_for)
    url = url + ".json"
    Rails.cache.fetch(url, expires: cache_for) do
      response = get(url)
      if response.success?
        response.parsed_response
      else
        raise response.message
      end
    end
  end
  # :nocov:

end
