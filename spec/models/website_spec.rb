require "rails_helper"

RSpec.describe Website, :type => :model do

  before do
    @website = FactoryBot.create(:website)
  end

  subject { @website }
  it { should respond_to(:brand) }

  describe "required settings" do
  	# it "should respond to support_email" do
  	# 	skip "Not sure what I'm hoping for here. Need to make sure sites all have a support email."
  	# 	website.support_email.wont_equal(nil)
  	# end
  end

  describe "locale" do
    it "returns the site's specified default locale" do
      @website.default_locale = "foo"

      expect(@website.locale).to eq "foo"
    end

    it "returns the brand's default locale" do
      @website.brand.default_locale = "zzz"

      expect(@website.locale).to eq "zzz"
    end

    it "returns the application's default locale" do
      @website.default_locale = ''
      @website.brand.default_locale = ''

      expect(@website.locale.to_s).to eq I18n.default_locale.to_s
    end

  end

end
