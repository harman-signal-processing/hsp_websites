require 'rails_helper'

RSpec.describe GetStartedPage, type: :model do

  before do
    @get_started_page = FactoryGirl.create(:get_started_page)
  end

  subject { @get_started_page }
  it { should respond_to(:brand) }
  it { should respond_to(:header_image) }
  it { should respond_to(:friendly_id) }
  it { should respond_to(:products) }
  it { should respond_to(:require_registration_to_unlock_panels?) }
  it { should respond_to(:get_started_panels) }

  it "should determine the cookie name to unlock panels" do
    expect(@get_started_page.cookie_name).to eq "registered_for_#{ @get_started_page.friendly_id }".to_sym
  end
end
