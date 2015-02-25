require "rails_helper"

RSpec.describe Website, :type => :model do

  before do
    @website = FactoryGirl.create(:website_with_products)
  end

  subject { @website }
  it { should respond_to(:brand) }

  describe "required settings" do
  	# it "should respond to support_email" do
  	# 	skip "Not sure what I'm hoping for here. Need to make sure sites all have a support email."
  	# 	website.support_email.wont_equal(nil)
  	# end
  end

end
