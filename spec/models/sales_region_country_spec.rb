require 'rails_helper'

RSpec.describe SalesRegionCountry, type: :model do

  before do
    @sales_region_country = FactoryBot.create(:sales_region_country)
  end

  subject { @sales_region_country }
  it { should respond_to :sales_region }
  it { should respond_to :name }
end
