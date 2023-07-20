require "rails_helper"

# Early on, Market Segments were poorly named. Today we call them
# Vertical Markets, but the name in the code persists.
feature "Browse Market Segments" do

  before :all do
    @website = FactoryBot.create(:website)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  describe "index" do
    it "redirects to product family index" do
      visit market_segments_path

      expect(page.current_path).to eq(product_families_path(locale: I18n.default_locale))
    end
  end

  describe "show page" do
    let(:market_segment) { create(:market_segment, brand: @website.brand) }

    it "shows the market segment page" do
      expect(CaseStudy).to receive(:find_by_website_or_brand).with(@website).and_return([])

      visit market_segment_path(market_segment, locale: I18n.default_locale)

      expect(page).to have_content(market_segment.name)
    end
  end

end
