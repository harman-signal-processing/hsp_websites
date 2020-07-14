class GetStartedPageProduct < ApplicationRecord
  belongs_to :get_started_page
  belongs_to :product
  validates :product, presence: true, uniqueness: { scope: :get_started_page, case_sensitive: false }
  validates :get_started_page, presence: true
end
