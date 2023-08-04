require "rails_helper"

RSpec.describe SeoHelper do

  describe "canonical URLs" do
    it "does not replace locale with default for site" do
      website = FactoryBot.create(:website)
      controller.request.host = website.url
      controller.request.path = "/en-GB/products/test-product"
      allow(helper).to receive(:website).and_return(website)
      allow(website).to receive(:list_of_available_locales).and_return(["en", "en-US", "en-GB"])

      canonical = helper.canonical_link

      expect(canonical).to match "#{ controller.request.host }/en-GB/products/test-product"
    end

    it "does not replace locale for landing pages" do
      website = FactoryBot.create(:website)
      controller.request.host = website.url
      controller.request.path = "/test-page"
      allow(helper).to receive(:website).and_return(website)
      allow(website).to receive(:list_of_available_locales).and_return(["en", "en-US", "en-GB"])

      canonical = helper.canonical_link

      expect(canonical).to match controller.request.url
    end

    it "consolidates www and non-www domains" do
      website = FactoryBot.create(:website)
      secondary_website = FactoryBot.create(:website, brand: website.brand)
      controller.request.host = secondary_website.url
      controller.request.path = "/en/products/test-product"
      allow(helper).to receive(:website).and_return(website)
      allow(website).to receive(:list_of_available_locales).and_return(["en", "en-US", "en-GB"])

      canonical = helper.canonical_link

      expect(canonical).to match "#{ website.url }/en/products/test-product"
      expect(canonical).not_to match "#{ secondary_website.url }/en/products/test-product"
    end

  end

end
