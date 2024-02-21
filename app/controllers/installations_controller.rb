class InstallationsController < ApplicationController
  before_action :load_and_authorize_installation, only: :show
  skip_before_action :verify_authenticity_token

  # GET /installations
  # GET /installations.xml
  def index
    @installations = website.brand.installations.order(:title)
    render_template
  end

  # GET /installations/1
  # GET /installations/1.xml
  def show
    respond_to do |format|
      format.html {
        if !@installation.layout_class.blank? && File.exist?(Rails.root.join("app", "views", website.folder, "installations", "#{@installation.layout_class}.html.erb"))
          render template: "#{website.folder}/installations/#{@installation.layout_class}", layout: set_layout
        else
          render_template
        end
      }
      format.xml  { render xml: @installation }
    end
  end

  private

  def load_and_authorize_installation
    if params[:id]
      @installation = Installation.find(params[:id])
      if !website.installations.include?(@installation)
        redirect_to root_path and return false
      end
    end
  end

end
