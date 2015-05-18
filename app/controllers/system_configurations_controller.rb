class SystemConfigurationsController < ApplicationController
	before_action :set_system, only: [:new, :create]
  before_action :set_system_configuration, only: [:show, :contact_for]

	def new
		@system_configuration = @system.system_configuration('configure', system_configuration_params)
    render_template
	end

	def create
    @system_configuration = SystemConfiguration.new(system_configuration_params)
    @system_configuration.system = @system
    if @system_configuration.save
      if params[:commit].to_s.match(/contact/i)
        redirect_to contact_for_system_system_configuration_path(@system, @system_configuration)
      else
        redirect_to [@system, @system_configuration]
      end
    else
      render action: 'new'
    end
	end

	def show
    render_template layout: printable
	end

  # TODO: make sure the custom recipients are contacted based on the selected system type
  def contact_for
    render_template
  end

private

  def printable
    name = "printable_system_configuration"
    File.exist?(Rails.root.join("app", "views", website.folder, "layouts", "#{name}.html.erb")) ?
      "#{website.folder}/layouts/#{name}" : name
  end

  def set_system
    @system = System.find(params[:system_id])
  end

  def set_system_configuration
    @system_configuration = SystemConfiguration.find(params[:id])
    @system = @system_configuration.system
  end

  def system_configuration_params
  	params.require(:system_configuration).permit!
  end

end
