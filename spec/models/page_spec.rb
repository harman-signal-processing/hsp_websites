require 'rails_helper'

RSpec.describe Page, type: :model do

  before do
    @page = create(:page)
  end

  subject { @page }
  it { should respond_to :brand }
  it { should respond_to :content_translations }

  describe "other_locales_with_translations()" do
    it "should include zh if zh translation is provided" do
      page = create(:page)
      website = build_stubbed(:website)
      create(:content_translation,
             translatable: page,
             content_method: "body",
             content: "Translated chinese text here",
             locale: "zh")
      list_of_other_locales = page.other_locales_with_translations(website)

      expect(list_of_other_locales).to include("zh")
    end
  end
end

