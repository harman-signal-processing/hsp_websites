FactoryBot.define do
  factory :vip_service_service_category, class: 'Vip::ServiceServiceCategory' do
    position { 1 }
    service { Vip::Service.create(name:'Touch Panel Design') }
    service_category { Vip::ServiceCategory.create(name:'Design') }
  end
end
