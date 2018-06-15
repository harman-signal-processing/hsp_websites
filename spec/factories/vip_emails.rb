FactoryBot.define do
  factory :vip_email, class: 'Vip::Email' do
    label "Email label"
    email "test@test.com"
  end
end
