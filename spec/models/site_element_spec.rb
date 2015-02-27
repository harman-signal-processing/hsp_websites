require "rails_helper"

RSpec.describe SiteElement, :type => :model do

  before do
    @site_element = FactoryGirl.build_stubbed(:site_element)
  end

  subject { @site_element }
  it { should respond_to(:brand) }

  describe "public downloads" do
    it "should require a resource type" do
      @site_element.show_on_public_site = true
      @site_element.resource_type = ''

      expect(@site_element.valid?).to be(false)
    end
  end

end
