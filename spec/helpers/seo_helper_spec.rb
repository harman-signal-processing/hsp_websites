require "rails_helper"

RSpec.describe SeoHelper do

  describe "canonical URLs" do
    it "replaces locale with default for site" do
      website = FactoryGirl.create(:website)
      controller.request.host = website.url
      controller.request.path = "/en-GB/products/test-product"
      allow(helper).to receive(:website).and_return(website)
      allow(website).to receive(:list_of_available_locales).and_return(["en", "en-US", "en-GB"])

      canonical = helper.canonical_link

      expect(canonical).to match "#{ controller.request.host }/en/products/test-product"
    end

    it "does not replace locale for non-locale URLs" do
      website = FactoryGirl.create(:website)
      controller.request.host = website.url
      controller.request.path = "/test-page"
      allow(helper).to receive(:website).and_return(website)
      allow(website).to receive(:list_of_available_locales).and_return(["en", "en-US", "en-GB"])

      canonical = helper.canonical_link

      expect(canonical).to match controller.request.url
    end

    it "rewrites complex, non-default locales to the default" do
      website = FactoryGirl.create(:website)
      controller.request.host = website.url
      controller.request.path = "/es-MX/products/test-product"
      allow(helper).to receive(:website).and_return(website)
      allow(website).to receive(:list_of_available_locales).and_return(["en", "en-US", "en-GB"])

      canonical = helper.canonical_link

      expect(canonical).to match "#{ controller.request.host }/en/products/test-product"
    end

    it "rewrites parent 'en-US' to 'en'" do
      website = FactoryGirl.create(:website)
      controller.request.host = website.url
      controller.request.path = "/en-US/products/test-product"
      allow(helper).to receive(:website).and_return(website)
      allow(website).to receive(:list_of_available_locales).and_return(["en", "en-US", "en-GB"])

      canonical = helper.canonical_link

      expect(canonical).to match "#{ controller.request.host }/en/products/test-product"
    end
  end

  describe "hreflang links" do
    it "generates alternate links for other languages" do
      skip "Revisit hreflang functions"
      website = FactoryGirl.create(:website)
      website.available_locales << FactoryGirl.create(:website_locale, locale: "es", name: "Spanish")
      controller.request.host = website.url
      controller.request.path = "/es/products/test-product"
      allow(helper).to receive(:website).and_return(website)

      links = helper.hreflang_links

      expect(links).to match controller.request.url
      expect(links).to match "/en/products/test-product"
      expect(links).to match "/en-US/products/test-product"
    end
  end
end
