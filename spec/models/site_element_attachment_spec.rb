require 'rails_helper'

RSpec.describe SiteElementAttachment, type: :model do

  before do
    @sea = FactoryBot.create(:site_element_attachment)
  end

  subject { @sea }
  it { should respond_to :site_element }
  it { should respond_to :attachment }

end
