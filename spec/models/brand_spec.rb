require 'rails_helper'

RSpec.describe Brand, :type => :model do

  before do
    @brand = FactoryGirl.create(:brand)
  end

  it "should create the counter with a value of 1" do
    @brand.increment_homepage_counter

    counter = @brand.settings.where(name: 'homepage_counter').first_or_create

    expect(counter.value).to eq(1)
  end

  it "should return the new counter value" do
    expect(@brand.increment_homepage_counter).to eq(1)
  end

  it "should reset itself if the counter was last updated yesterday" do
    counter = FactoryGirl.create(:setting,
                                 name: 'homepage_counter',
                                 setting_type: 'integer',
                                 integer_value: 99,
                                 brand_id: @brand.id,
                                 updated_at: 1.day.ago)
    @brand.increment_homepage_counter
    counter.reload

    expect(counter.value).to eq(1)
  end
end
