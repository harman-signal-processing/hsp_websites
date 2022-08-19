class GetStartedPanel < ApplicationRecord
  belongs_to :get_started_page

  acts_as_list scope: :get_started_page
end
