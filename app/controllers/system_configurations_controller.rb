class SystemConfigurationsController < ApplicationController
	before_action :set_system

	def new
		@system_configuration = @system.system_configuration('configure', system_configuration_params)
	end

	def create
		render text: "Saving the configured system is not yet implemented."
	end

	def show
		render text: @system_configuration.to_yaml
	end

private

  def set_system
    @system = System.find(params[:system_id])
  end

  def system_configuration_params
  	params.require(:system_configuration).permit!
  end

end
