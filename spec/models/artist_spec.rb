require "rails_helper"

RSpec.describe Artist, :type => :model do

  describe "relations" do

		before :all do
      @website = FactoryBot.create(:website_with_products, folder: "digitech")
	  end

	  it "should return a brand for the mailer when artist has products" do
      @artist = FactoryBot.create(:artist, products: @website.products)

      expect(@artist.brand_for_mailer).to be_a(Brand)
	  end

    it "should return a brand for the mailer when artist has brands" do
      @artist = FactoryBot.create(:artist, initial_brand: @digitech)

      expect(@artist.brand_for_mailer).to be_a(Brand)
    end
  end

end
