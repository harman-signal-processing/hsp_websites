FactoryBot.define do
  factory :vip_programmer_skill, class: 'Vip::ProgrammerSkill' do
    position { 1 }
    programmer { Vip::Programmer.create(name: 'Programmer 1') }
    skill { Vip::Skill.create(name: 'AMX Duet Developer') }
  end
end
