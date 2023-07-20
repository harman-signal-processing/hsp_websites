require 'rails_helper'

RSpec.describe DistributorUser, :type => :model do

  before do
    @distributor_user = create(:distributor_user)
  end

  subject { @distributor_user }
  it { should respond_to :distributor }
  it { should respond_to :user }

end

