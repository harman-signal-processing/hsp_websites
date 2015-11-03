require "rails_helper"

RSpec.describe ProductFamiliesHelper do

  before :all do
    @product_family = FactoryGirl.build_stubbed(:product_family)
  end

  describe "links_to_related_product_families" do
    it "returns links to related families" do
      related = FactoryGirl.build_stubbed(:product_family)
      expect(@product_family).to receive(:siblings_with_current_products).and_return([related])

      links = helper.links_to_related_product_families(@product_family)

      expect(links).to have_link(related.name)
    end
  end
end
