require 'rails_helper'

RSpec.describe SalesRegion, type: :model do

  before do
    @sales_region = FactoryBot.create(:sales_region)
  end

  subject { @sales_region }
  it { should respond_to :brand }
  it { should respond_to :sales_region_countries }
  it { should respond_to :support_email }
end
