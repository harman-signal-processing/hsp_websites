FactoryBot.define do
  factory :training_class do
    training_course
    start_at { 2.weeks.from_now }
    end_at { 3.weeks.from_now }
    language { "en" }
    instructor_id { 1 }
    location { "Northridge" }
    filled { false }
  end

end


