require "test_helper"

describe "DigiTech Artist Integration Test" do

  before :each do
    DatabaseCleaner.start
    Brand.destroy_all
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}"

    #
    # This is a lot of setup code. We are using Devise for registrations, so that
    # kind of messes with the FactoryGirl fixtures. Instead of letting FG create our
    # records, we're going through the regular AR create method so we can .skip_confirmation!
    # The other thing is, we have to have at least these two tiers created in order for
    # it all to work. Kind of a mess, but at least it is sorted out here:
    #
    @affiliate_tier = FactoryGirl.create(:affiliate_tier)
    @top_tier = FactoryGirl.create(:top_tier)
    first_artist_attr = FactoryGirl.attributes_for(:artist, featured: true, artist_tier: @top_tier)
    @first_artist = Artist.new(first_artist_attr)
    @first_artist.skip_unapproval = true
    @first_artist.approver_id = 99
    @first_artist.initial_brand = @brand
    @first_artist.skip_confirmation!
    @first_artist.save!
    FactoryGirl.create(:artist_brand, artist: @first_artist, brand: @brand)
    FactoryGirl.create(:artist_product, product: @website.products.first, artist: @first_artist)

  end

  after :each do
    DatabaseCleaner.clean
  end

  describe "Artist Page" do
  	before do
  		visit artists_url(locale: I18n.default_locale, host: @website.url)
  	end

  	it "should show the featured artist" do
  		page.must_have_xpath("//img[@src='#{@first_artist.artist_photo.url(:feature)}']")
  	end
  end

  describe "Signup" do
  	before do
  		visit artists_url(locale: I18n.default_locale, host: @website.url)
  	end

  	it "should have a signup form" do
      wont_have_link "Become a #{@brand.name} Artist"
  		click_link "Artist Login"
  		click_link "Sign up to be a #{@brand.name} Artist"
  		must_have_xpath("//form[@id='new_artist']")
  	end

  end

  describe "Affiliate" do
    describe "Signup without invitation" do
      before do
        visit new_artist_registration_url(locale: I18n.default_locale, host: @website.url)
      end

      it "should be an affiliate" do
        count = Artist.count
        fill_in 'artist_name', with: "Joe Schmoe"
        fill_in 'artist_email', with: "joe@schmoe.com"
        fill_in 'artist_password', with: "Pass123"
        fill_in 'artist_password_confirmation', with: "Pass123"
        click_button "Sign up"
        current_path.must_equal(become_an_artist_path(locale: I18n.default_locale))
        must_have_content "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
        Artist.count.must_equal (count + 1)
        new_artist = Artist.last
        new_artist.approver_id.must_equal(nil)
        new_artist.artist_tier.must_equal(@affiliate_tier)
      end
    end

    describe "Show page" do
      before do
        @artist = @first_artist
        @artist.artist_tier = @affiliate_tier
        @artist.skip_unapproval = true
        @artist.save
        visit artist_url(@artist, locale: I18n.default_locale, host: @website.url)
      end

      it "should NOT have the big pic banner" do
        wont_have_xpath("//div[@id='big_artist_photo']/img[@src='#{@artist.artist_photo.url(:feature)}']")
      end

    end

  end

  describe "Top-tier" do

    describe "Signup with an invitation code" do
      before do
        visit new_artist_registration_url(locale: I18n.default_locale, host: @website.url)
      end

      it "should be top-tier" do
        fill_in 'artist_name', with: "Robert Smith"
        fill_in 'artist_email', with: "robert.smith@thecure.com"
        fill_in 'artist_password', with: "elise"
        fill_in 'artist_password_confirmation', with: "elise"
        fill_in 'artist_invitation_code', with: @top_tier.invitation_code
        click_button "Sign up"
        new_artist = Artist.last
        new_artist.artist_tier.must_equal(@top_tier)
      end     
    end

    describe "Show page" do
      before do
        @artist = @first_artist
        @artist.artist_tier = @top_tier
        @artist.skip_unapproval = true
        @artist.save
        visit artist_url(@artist, locale: I18n.default_locale, host: @website.url)
      end

      it "should have the big pic banner" do
        must_have_xpath("//div[@id='big_artist_photo']/img[@src='#{@artist.artist_photo.url(:feature)}']")
      end

    end

  end

end