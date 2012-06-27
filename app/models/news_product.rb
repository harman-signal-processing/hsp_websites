class NewsProduct < ActiveRecord::Base
  belongs_to :news, touch: true
  belongs_to :product, touch: true
end
