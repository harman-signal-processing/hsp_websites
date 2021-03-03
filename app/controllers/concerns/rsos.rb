module Rsos
  extend ActiveSupport::Concern

  def get_rsos(country_code)
    if country_code.empty?
      return []
    else
      url = "#{ENV['PRO_SITE_URL']}/contact_info/rso/#{country_code.downcase}.json"
      encoded_url = URI.encode(url)

      response = HTTParty.get(encoded_url, ssl_version: :TLSv1_2)
      if response.success?
        result = response.deep_symbolize_keys
      else
        raise response.message
      end

      result[:rsos]
    end  # else of if country_code.empty?
  end	 # def get_rsos(country_code)
end  #  module Rsos
