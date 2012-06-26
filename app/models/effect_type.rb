class EffectType < ActiveRecord::Base
  has_many :effects
  acts_as_list
end
