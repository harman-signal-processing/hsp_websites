require 'rails_helper'

RSpec.describe "admin/support_subjects/show.html.erb" do

  before do
    @brand = FactoryGirl.create(:brand)
    @website = FactoryGirl.create(:website, brand: @brand)
    #allow(view).to receive_messages(:website => @website)
    @support_subject = FactoryGirl.create(:support_subject, brand: @brand)
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
