class SystemConfigurationsController < ApplicationController
	before_action :set_system, only: [:new, :edit, :update, :create]
  before_action :set_system_configuration, only: [:show, :edit, :update, :contact_form]

	def new
		@system_configuration = @system.system_configuration('configure', system_configuration_params)
    render_template
	end

  def edit
    render_template
  end

	def show
    render_template layout: printable
	end

	def create
    @system_configuration = SystemConfiguration.new(system_configuration_params)
    @system_configuration.system = @system
    if @system_configuration.save
      if params[:commit].to_s.match(/contact/i)
        redirect_to contact_form_system_system_configuration_path(@system, @system_configuration, access_hash: @system_configuration.access_hash)
      else
        redirect_to show_system_system_configuration_path(@system, @system_configuration, access_hash: @system_configuration.access_hash)
      end
    else
      render action: 'new'
    end
	end

  # TODO: make sure the custom recipients are contacted based on the selected system type
  def contact_form
    if request.post?
      if @system_configuration.update_attributes(system_configuration_params)
        SiteMailer.delay.new_system_configuration(@system_configuration)
        redirect_to show_system_system_configuration_path(@system, @system_configuration, access_hash: @system_configuration.access_hash), notice: "Thanks! We'll get back with you shortly." and return false
      end
    end
    render_template
  end

  def update
    if @system_configuration.update_attributes(system_configuration_params)
      if params[:commit].to_s.match(/contact/i)
        redirect_to contact_form_system_system_configuration_path(@system, @system_configuration, access_hash: @system_configuration.access_hash)
      else
        redirect_to show_system_system_configuration_path(@system, @system_configuration, access_hash: @system_configuration.access_hash)
      end
    else
      render action: 'edit'
    end
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
    @system_configuration = SystemConfiguration.find_by(id: params[:id], access_hash: params[:access_hash])
    if @system_configuration
      @system = @system_configuration.system
    else
      redirect_to systems_path, alert: "System configuration not found" and return false
    end
  end

  def system_configuration_params
  	params.require(:system_configuration).permit!
  end

end
