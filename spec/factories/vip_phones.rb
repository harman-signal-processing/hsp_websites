FactoryBot.define do
  factory :vip_phone, class: 'Vip::Phone' do
    label { "Phone label" }
    phone { "123-456-7890" }
  end
end
