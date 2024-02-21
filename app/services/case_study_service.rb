module CaseStudyService

  def self.get_case_study_data(brand_name)
      url = "#{ENV['PRO_SITE_URL']}/api/v1/case_studies/#{brand_name}"
      encoded_url = URI::Parser.new.escape(url)
      response = HTTParty.get(encoded_url, ssl_version: :TLSv1_2)
      if response.success?
        # result = JSON.parse(response).deep_symbolize_keys
        result = response.deep_symbolize_keys
        result[:case_studies]
      else
        raise response.message
      end
  end  #  self.get_case_study_data

  def self.get_case_study_item_list_from_cache(brand_name)
    cache_for = Rails.env.production? ? 1.hour : 1.minute
    Rails.cache.fetch("#{brand_name}_case_studies", expires_in: cache_for, race_condition_ttl: 10) do
        self.get_case_study_data(brand_name)
    end  #  Rails.cache.fetch("#{brand_name}case_studies", expires_in: cache_for, race_condition_ttl: 10) do
  end  #  def self.get_case_study_item_list_from_cache(brand_name)

end  #  module CaseStudyService
