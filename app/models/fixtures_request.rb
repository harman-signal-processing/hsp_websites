class FixturesRequest < ApplicationRecord

  has_attached_file :attachment
  validates_attachment_content_type :attachment, content_type: /zip|pdf/i

  validates :email, presence: true, email: true
  validates :manufacturer, :fixture_name, :product_link, presence: true

  after_create :send_request, :auto_prune

  def send_request
    SiteMailer.delay.fixtures_request(self)
  end

  def auto_prune
    FixturesRequest.auto_prune
  end
  handle_asynchronously :auto_prune

  def self.auto_prune
    where("created_at < ?", 1.week.ago.to_time).delete_all
  end
end
