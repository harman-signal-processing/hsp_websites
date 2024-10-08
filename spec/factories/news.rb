FactoryBot.define do

  factory :news do
    sequence(:title) {|n| "The most amazing story #{n}" }
    body { "This is a very important news story." }
    post_on { 2.days.ago }
    factory :old_news do
      post_on { 3.years.ago }
    end
  end

  factory :news_product do
    news
    product
  end

  factory :brand_news do
    brand
    news
  end

end
