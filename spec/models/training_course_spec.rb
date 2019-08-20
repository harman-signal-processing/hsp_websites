require 'rails_helper'

RSpec.describe TrainingCourse, type: :model do

  before do
    @training_course = FactoryBot.create(:training_course)
  end

  subject { @training_course }
  it { should respond_to :upcoming_classes }
  it { should respond_to :training_classes }
  it { should respond_to :brand }

  describe ".upcoming_classes" do
    it "should return related classes in the future" do
      training_class = FactoryBot.create(:training_class, training_course: @training_course, start_at: 2.weeks.from_now)

      expect(@training_course.upcoming_classes).to include(training_class)
    end

    it "should not return related classes from the past" do
      training_class = FactoryBot.create(:training_class, training_course: @training_course, start_at: 2.weeks.ago)

      expect(@training_course.upcoming_classes).not_to include(training_class)
    end
  end
end
