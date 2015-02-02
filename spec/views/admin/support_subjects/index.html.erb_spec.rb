require 'rails_helper'

RSpec.describe "admin/support_subjects/index.html.erb" do

  before do
    @brand = FactoryGirl.create(:brand)
    @website = FactoryGirl.create(:website, brand: @brand)
    #allow(view).to receive_messages(:website => @website)
  end

  context "with no existing subjects" do
    it "gives a message explaining defaults are used" do
      render
      expect(rendered).to have_content("default subjects")
    end
  end

  context "with existing subjects" do
    before do
      @support_subjects = FactoryGirl.create_list(:support_subject, 3, brand: @brand)
      assign(:support_subjects, @support_subjects)
      render
    end

    it "lists the subjects with links to view/edit" do
      expect(rendered).to have_link(@support_subjects.first.name, href: admin_support_subject_path(@support_subjects.first))
    end
  end

  it "has button to create new subject" do
    render
    expect(rendered).to have_link("New", href: new_admin_support_subject_path)
  end
end
