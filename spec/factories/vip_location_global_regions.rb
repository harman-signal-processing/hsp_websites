FactoryBot.define do
  factory :vip_location_global_region, class: 'Vip::LocationGlobalRegion' do
    position 1
    location { Vip::Location.create(city:'Richardson', country:'United States')}
    global_region { Vip::GlobalRegion.create(name:'North America') }
  end
end
