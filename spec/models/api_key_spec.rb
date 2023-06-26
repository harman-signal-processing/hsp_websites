require 'rails_helper'

RSpec.describe ApiKey, :type => :model do

  before do
    @api_key = create(:api_key)
  end

  subject { @api_key }
  it { should respond_to :description }

  it "should generate a random key" do
    expect(@api_key.access_token.size).to be(32)
  end
end


