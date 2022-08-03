class GetStartedPageProduct < ApplicationRecord
  belongs_to :get_started_page
  belongs_to :product
  validates :product, uniqueness: { scope: :get_started_page, case_sensitive: false }
end
