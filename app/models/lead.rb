class Lead < ApplicationRecord

  validates :name, presence: true
  validates :email, presence: true
  validates :country, presence: true

  before_create :convert_country
  after_create :sync_to_hpro

  def sync_to_hpro
    res = HTTParty.post(
      "#{ENV['PRO_SITE_URL']}/api/v1/leads", {
        body: { lead: self.attributes }.to_json,
        headers: {
         'Content-Type' => 'application/json',
         'Accept' => 'application/json'
        }
      }
    )

    if res.success?
      self.destroy
    else
      raise res.message
    end
  end
  handle_asynchronously :sync_to_hpro

  def convert_country
    unless country.to_s.match(/[A-Z]{2}/)
      if country_obj = ISO3166::Country.find_country_by_name(country)
        self.country = country_obj.alpha2
      end
    end
  end

end
