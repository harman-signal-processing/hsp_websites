require 'rails_helper'

RSpec.describe OnlineRetailerUser, :type => :model do

  before do
    @online_retailer_user = create(:online_retailer_user)
  end

  subject { @online_retailer_user }
  it { should respond_to :online_retailer }
  it { should respond_to :user }

end


