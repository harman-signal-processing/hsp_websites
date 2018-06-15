FactoryBot.define do
  factory :vip_location, class: 'Vip::Location' do
    name "Location name"
    city "Location city"
    state "Location state"
    country "Location country"
  end
end
