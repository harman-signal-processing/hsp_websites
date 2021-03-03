module Distributors
  extend ActiveSupport::Concern

  def get_international_distributors(brand, country_code)

    if brand.empty? || country_code.empty?
      return []
    else
      url = "#{ENV['PRO_SITE_URL']}/distributor_info/distributors/#{brand.downcase}/#{country_code.downcase}.json"
      encoded_url = URI.encode(url)

      response = HTTParty.get(encoded_url, ssl_version: :TLSv1_2)
      if response.success?
        result = response.deep_symbolize_keys
      else
        raise response.message
      end

      result[:distributors]
    end  #  else of if brand.empty? || country_code.empty?
  end	 # def get_international_distributors(brand, country_code)
end  #  module Distributors
