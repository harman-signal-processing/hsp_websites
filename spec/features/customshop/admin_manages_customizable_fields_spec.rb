require "rails_helper"

feature "An admin manages customizable fields" do

  before do
    @website = FactoryBot.create(:website)
    @brand = @website.brand
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"

    @user = FactoryBot.create(:user, custom_shop_admin: true, password: "password", confirmed_at: 1.minute.ago)
    admin_login_with(@user.email, "password", @website)
  end

  describe "Customizable fields" do
    it "is successful" do
      skip "Add specs for managing customizable fields"
    end
  end
end

