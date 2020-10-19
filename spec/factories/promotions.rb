FactoryBot.define do

  factory :promotion do
    sequence(:name) {|n| "MIR #{n}"}
    brand
    start_on { 2.weeks.ago }
    end_on { 2.weeks.from_now }
    description { "Get more info" }
    promo_form { File.new(Rails.root.join('spec', 'fixtures', 'test.pdf')) }
    tile { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
    post_registration_subject { nil }
    post_registration_message { nil }
    send_post_registration_message { false }
    factory :expired_promotion do
      end_on { 2.weeks.ago }
    end
  end

  factory :product_promotion do
    product
    promotion
  end

end
