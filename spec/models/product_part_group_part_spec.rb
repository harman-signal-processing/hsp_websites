require 'rails_helper'

RSpec.describe ProductPartGroupPart, type: :model do

  before do
    @product_part_group_part = FactoryBot.build_stubbed(:product_part_group_part)
  end

  subject { @product_part_group_part }
  it { should respond_to(:part) }
  it { should respond_to(:product_part_group) }
end
