FactoryBot.define do

  factory :website do
    sequence(:url) {|n| "example#{n}.lvh.me" }
    brand
    folder { "testbrand" }
    after(:create) do |website|
      FactoryBot.create(:website_locale, website: website, default: true)
    end
    factory :website_with_products do
      after(:create) do |website|
        FactoryBot.create_list(:product_family_with_products, 2, brand: website.brand)
      end
    end
  end

  factory :website_locale do
    name { "English (USA)" }
    locale { I18n.default_locale }
    complete { true }
    default { false }
    website
  end

end
