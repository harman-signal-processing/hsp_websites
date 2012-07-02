# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tweet do
    brand_id 1
    tweet_id "MyString"
    screen_name "MyString"
    content "MyText"
    profile_image_url "MyString"
    posted_at "2012-07-02 08:49:48"
  end
end
