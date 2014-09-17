# System is used to configure IDX (and possibly other) systems. It consists of nested
# options and values. Selected values may trigger one or more SystemActions.
#
class System < ActiveRecord::Base
	has_many :system_options
	has_many :system_rules
	has_many :system_configurations
	has_many :system_components
	belongs_to :brand

	validates :brand, presence: true
	validates :name, presence: true, uniqueness: { scope: :brand_id }

	def options_with_possible_values
		option_ids = SystemOptionValue.where(id: self.system_options).pluck(:system_option_id).uniq
		system_options.where(id: option_ids)
	end

	def system_options_for_start_page
		@system_options_for_start_page ||= self.system_options.where(show_on_first_screen: true)
	end

	def parent_system_options
		@parent_system_options ||= system_options.where("parent_id IS NULL")
	end

	def parent_system_options_for_start_page
		@parent_system_options_for_start_page ||= parent_system_options.where(show_on_first_screen: true)
	end	

	# Blank system config
	def system_configuration(stage='configure', options={})
		@system_configuration ||= SystemConfiguration.new
		configured_option_ids = @system_configuration.system_configuration_options.map{|sco| sco.system_option_id}

		if options[:system_configuration_options_attributes]
			options[:system_configuration_options_attributes].each do |key, scoa|
				sco = SystemConfigurationOption.new(scoa)
				@system_configuration.system_configuration_options << sco
				configured_option_ids << sco.system_option_id
			end
		end

		options_to_build = case stage
			when 'start'
				system_options_for_start_page
			when 'parents'
				parent_system_options
			else
				system_options
		end

		options_to_build.each do |system_option|
			unless configured_option_ids.include?(system_option.id)
				@system_configuration.system_configuration_options << SystemConfigurationOption.new(
					system_option: system_option,
					direct_value: system_option.default_direct_value,
					system_option_value_id: system_option.default_system_option_value_id
				)
				configured_option_ids << system_option.id
			end
		end

		@system_configuration
	end

end
