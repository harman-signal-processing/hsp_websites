class SupportSubject < ActiveRecord::Base
  belongs_to :brand
  validates :name, presence: true, uniqueness: { scope: :brand_id }

  def recipient
    self.read_attribute(:recipient) || default_recipient
  end

  def default_recipient
    @default_recipient ||= brand.support_email
  end
end
