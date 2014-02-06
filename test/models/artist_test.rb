require "test_helper"

describe Artist do 

  before :each do
  	DatabaseCleaner.start
  	Artist.destroy_all
  end

  after :each do
    DatabaseCleaner.clean
  end

  describe "relations" do

		before :each do
	  	@artist = FactoryGirl.create(:artist)
	  end

	  it "should return a brand for the mailer" do 
	  	assert @artist.brand_for_mailer.is_a?(Brand)
	  end

  end
 
end