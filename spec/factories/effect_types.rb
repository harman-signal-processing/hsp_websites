FactoryBot.define do
	factory :effect_type do
		sequence(:name) {|n| "EffectType #{n}" }
	end
end

