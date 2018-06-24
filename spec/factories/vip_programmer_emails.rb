FactoryBot.define do
  factory :vip_programmer_email, class: 'Vip::ProgrammerEmail' do
    position 1
    programmer { Vip::Programmer.create(name:'Programmer 1') }
    email { Vip::Email.create(label: 'Email label', email: 'test@test.com') }
  end
end
