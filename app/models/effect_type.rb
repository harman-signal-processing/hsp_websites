class EffectType < ApplicationRecord
  has_many :effects
  acts_as_list

end
