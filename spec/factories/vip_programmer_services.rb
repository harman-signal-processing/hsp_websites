FactoryBot.define do
  factory :vip_programmer_service, class: 'Vip::ProgrammerService' do
    position { 1 }
    programmer { Vip::Programmer.create(name:'Programmer 1') }
    service { Vip::Service.create(name: 'Touch Panel Design') }
  end
end
