require 'rails_helper'

RSpec.describe ProductPartGroup, type: :model do

  before do
    @product_part_group= FactoryBot.build_stubbed(:product_part_group)
  end

  subject { @product_part_group}
  it { should respond_to(:product) }
  it { should respond_to(:product_part_group_parts) }
  it { should respond_to(:parts) }
end
