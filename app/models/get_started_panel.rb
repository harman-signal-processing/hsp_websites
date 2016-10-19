class GetStartedPanel < ActiveRecord::Base
  belongs_to :get_started_page

  validates :get_started_page, presence: true
  acts_as_list scope: :get_started_page
end
