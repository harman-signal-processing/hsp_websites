FactoryBot.define do
  factory :training_class_registration do
    training_class_id
    name { "Johnny Johnson" }
    email { "johnny@johnson.com" }
    comments { "This is the best class." }
  end
end
