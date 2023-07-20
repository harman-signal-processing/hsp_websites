require 'rails_helper'

RSpec.describe EffectType, :type => :model do

  before do
    @effect_type = create(:effect_type)
  end

  subject { @effect_type }
  it { should respond_to :effects }
  it { should respond_to :name }

end


