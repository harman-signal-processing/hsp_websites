class ProductFamilyCaseStudy < ApplicationRecord
  include HTTParty
  format :json

  belongs_to :product_family, touch: true

  validates :case_study_id, presence: true

  acts_as_list scope: :product_family

  def self.base_url
    ENV['PRO_SITE_URL']
  end

  def case_study
    @case_study ||= get_case_study_details[:case_study]
  end

  def headline
    self.case_study[:headline]
  end

  def banner_url
    self.case_study[:banner_url]
  end

  def small_panel_banner_url
    self.case_study[:small_panel_banner_url]
  end

  def published_on
    self.case_study[:published_on]
  end

  private

  def get_case_study_details
    path = "/case_studies/#{self.case_study_id}.json"
    begin
      self.class.get_api_response(path, 8.hours)
    rescue
      {}
    end
  end

  # :nocov:
  def self.get_api_response(path, cache_for)
    cache_for = 1.minute unless Rails.env.production?
    url = "#{base_url}#{path}"
    Rails.cache.fetch(url, expires_in: cache_for, race_condition_ttl: 10) do
      response = HTTParty.get(url, format: :plain)
      if response.success?
        JSON.parse response, symbolize_names: true
      else
        raise response.message
      end
    end
  end
  # :nocov:
end
