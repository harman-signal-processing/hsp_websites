FactoryBot.define do
  factory :faq_category do
    sequence(:name) {|n|  "FAQ Category ##{n}"}
    brand
  end

end
