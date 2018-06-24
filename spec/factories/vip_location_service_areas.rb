FactoryBot.define do
  factory :vip_location_service_area, class: 'Vip::LocationServiceArea' do
    position 1
    location { Vip::Location.create(city:'Richardson', country:'United States') }
    service_area { Vip::ServiceArea.create(name:'National') }
  end
end
