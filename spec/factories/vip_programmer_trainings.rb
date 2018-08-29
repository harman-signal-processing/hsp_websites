FactoryBot.define do
  factory :vip_programmer_training, class: 'Vip::ProgrammerTraining' do
    position { 1 }
    programmer { Vip::Programmer.create(name: 'Programmer 1') }
    training { Vip::Training.create(name: 'AMX') }
  end
end
