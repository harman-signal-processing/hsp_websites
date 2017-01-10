class SolutionMarket
  include HTTParty

  format :json

  def self.all
    begin
      get_api_response(base_url, 8.hours)["vertical_markets"]
    rescue
      []
    end
  end

  def self.find(id)
    url = base_url + "/#{id}"
    begin
      get_api_response(url, 8.hours)["vertical_market"]
    rescue
      {}
    end
  end

  def self.parents
    begin
      all.select{|v| v["parent_id"].nil?}
    rescue
      []
    end
  end

  private

  def self.base_url
    "#{ENV['PRO_SITE_URL']}/applications"
  end

  # :nocov:
  def self.get_api_response(url, cache_for)
    url = url + ".json"
    cache_for = 1.minute unless Rails.env.production?
    Rails.cache.fetch(url, expires_in: cache_for, race_condition_ttl: 10) do
      response = HTTParty.get(url)
      if response.success?
        response.parsed_response
      else
        raise response.message
      end
    end
  end
  # :nocov:

end
