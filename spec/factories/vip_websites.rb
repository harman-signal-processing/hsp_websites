FactoryBot.define do
  factory :vip_website, class: 'Vip::Website' do
    url { "https://test.com" }
  end
end
