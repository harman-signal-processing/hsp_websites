FactoryBot.define do
  factory :vip_programmer_location, class: 'Vip::ProgrammerLocation' do
    position { 1 }
    programmer { Vip::Programmer.create(name:'Programmer 1') }
    location { Vip::Location.create(city:'Richardson', country:'United States') }
  end
end
