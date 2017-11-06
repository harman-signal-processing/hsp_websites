require 'rails_helper'

RSpec.describe SupportSubject, :type => :model do

  before do
    @support_subject = FactoryBot.create(:support_subject)
    @brand = @support_subject.brand
  end

  subject { @support_subject }

  it { should respond_to(:brand) }
  it { should respond_to(:locale) }

  it "should default to the brand support email when no recipient is provided" do
    expect(@support_subject.recipient).to eq(@brand.support_email)
  end

  it "should not use the default when recipient is provided" do
    @support_subject.update_column(:recipient, "somebody@foo.com")

    expect(@support_subject.recipient).to eq("somebody@foo.com")
  end
end
