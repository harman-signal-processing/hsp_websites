require "test_helper"

describe Artist do 

  # before :each do
  # 	DatabaseCleaner.start
  # 	Artist.destroy_all
  # end

  # after :each do
  #   DatabaseCleaner.clean
  # end

  describe "relations" do

		before :each do
      @digitech = FactoryGirl.create(:digitech_brand)
      @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @digitech)
	  end

	  it "should return a brand for the mailer when artist has products" do 
      @artist = FactoryGirl.create(:artist, products: @website.products)
	  	assert @artist.brand_for_mailer.is_a?(Brand)
	  end

    it "should return a brand for the mailer when artist has brands" do 
      @artist = FactoryGirl.create(:artist, initial_brand: @digitech)
      assert @artist.brand_for_mailer.is_a?(Brand)
    end
  end
 
end