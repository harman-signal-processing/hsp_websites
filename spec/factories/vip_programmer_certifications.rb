FactoryBot.define do
  factory :vip_programmer_certification, class: 'Vip::ProgrammerCertification' do
    position 1
    programmer { Vip::Programmer.create(name: 'Programmer 1') }
    certification { Vip::Certification.create(name: 'AMX Solution Master') }
  end
end
