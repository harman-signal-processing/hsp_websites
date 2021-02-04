require 'rails_helper'

RSpec.describe "admin/support_subjects/show.html.erb" do

  before :all do
    @brand = FactoryBot.create(:brand)
    @website = FactoryBot.create(:website, brand: @brand)
    @support_subject = FactoryBot.create(:support_subject, brand: @brand, recipient: "foo@foo.com", locale: "en")
  end

  before :each do
    allow(view).to receive(:website).and_return(@website)
    assign(:support_subject, @support_subject)
    render
  end

  it "shows the subject text" do
    expect(rendered).to have_content(@support_subject.name)
  end

  it "shows the subject recipient" do
    expect(rendered).to have_content(@support_subject.recipient)
  end

  it "shows the subject locale" do
    expect(rendered).to have_content(@support_subject.locale)
  end

  it "shows the edit and delete buttons" do
    expect(rendered).to have_link("Delete", href: admin_support_subject_path(@support_subject))
    expect(rendered).to have_link("Edit", href: edit_admin_support_subject_path(@support_subject))
  end
end
