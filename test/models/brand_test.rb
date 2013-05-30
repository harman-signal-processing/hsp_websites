require "test_helper"

describe Brand do 

  before :each do
  	DatabaseCleaner.start
  	Brand.destroy_all
  end

  after :each do
    DatabaseCleaner.clean
  end

	describe "homepage counter" do
  
		before :each do
	  	@brand = FactoryGirl.create(:brand)
	  end

	  it "should create the counter with a value of 1" do
	    @brand.increment_homepage_counter
	    @brand.settings.where(name: 'homepage_counter').first_or_create.value.must_equal(1)
	  end

	  it "should return the new counter value" do 
	  	@brand.increment_homepage_counter.must_equal(1)
	  end

	  it "should reset itself if the counter was last updated yesterday" do
	  	counter = FactoryGirl.create(:setting, name: 'homepage_counter', setting_type: 'integer', integer_value: 99, brand_id: @brand.id, updated_at: 1.day.ago)
	  	@brand.increment_homepage_counter
	  	counter.reload
	  	counter.value.must_equal(1)
	  end
  end
 
end