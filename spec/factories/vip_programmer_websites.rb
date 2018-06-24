FactoryBot.define do
  factory :vip_programmer_website, class: 'Vip::ProgrammerWebsite' do
    position 1
    programmer { Vip::Programmer.create(name: 'Programmer 1') }
    website { Vip::Website.create(url: 'https://test.com') }
  end
end
