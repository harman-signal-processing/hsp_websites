FactoryGirl.define do
  factory :event do
    name "EventName"
    description "EventDescription"
    page_content "Event details..."
    start_on 1.week.from_now
    end_on 2.weeks.from_now
    image { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
    active false
    more_info_link "http://fool..com"
    new_window false
    brand
  end
end
