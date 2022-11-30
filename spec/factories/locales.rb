FactoryBot.define do
  factory :locale do
    code { I18n.default_locale }
    name { "English US" }
  end
end
