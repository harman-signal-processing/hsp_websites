require "rails_helper"

RSpec.describe "admin/support_subjects/_form.html.erb", type: :view do

  before :all do
    @brand = FactoryBot.create(:brand)
    @website = FactoryBot.create(:website, brand: @brand)
    @support_subject = FactoryBot.create(:support_subject, brand: @brand)
  end

  before :each do
    assign(:support_subject, @support_subject)
    allow(view).to receive(:website).and_return(@website)
    render partial: "admin/support_subjects/form"
  end

  it "has name, recipient, locale fields" do
    expect(rendered).to have_css("input#support_subject_name")
    expect(rendered).to have_css("input#support_subject_recipient")
    expect(rendered).to have_css("select#support_subject_locale")
  end
end
