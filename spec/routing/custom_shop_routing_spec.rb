require "rails_helper"

RSpec.describe CustomShopController, type: :routing do
  before do
    @locale = I18n.default_locale.to_s
  end

  describe "routing" do
    it "routes to #index" do
      expect(get: "/#{@locale}/custom_shop").to route_to("custom_shop#index", locale: @locale)
    end
  end

end

