FactoryBot.define do
  factory :vip_programmer_phone, class: 'Vip::ProgrammerPhone' do
    position 1
    programmer { Vip::Programmer.create(name: 'Programmer 1') }
    phone { Vip::Phone.create(label: 'Phone label', phone: '123-456-7890')}
  end
end
