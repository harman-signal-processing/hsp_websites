require "rails_helper"

feature "User confirmation" do

  before :all do
    @host = HarmanSignalProcessingWebsite::Application.config.toolkit_url
    Capybara.default_host = "http://#{@host}"
    Capybara.app_host = "http://#{@host}"
  end

  before :each do
    allow_any_instance_of(Dealer).to receive(:geocode_address).and_return(true)
  end

  scenario "should confirm the new user" do
    @dealer = FactoryGirl.create(:dealer)
    @user = FactoryGirl.create(:user, dealer: true, account_number: @dealer.account_number)

    last_email = ActionMailer::Base.deliveries.last
    last_email.body.to_s.match(/href\=\"(.*)\"+/)
    visit $1

    @user.reload
    expect(@user.confirmed?).to be(true)
  end

end
