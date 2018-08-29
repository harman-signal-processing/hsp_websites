FactoryBot.define do
  factory :vip_programmer_market, class: 'Vip::ProgrammerMarket' do
    position { 1 }
    programmer { Vip::Programmer.create(name: 'Programmer 1') }
    market { Vip::Market.create(name: 'Education') }
  end
end
