class InstallationsController < ApplicationController
  before_filter :load_and_authorize_installation, only: :show
  skip_before_filter :verify_authenticity_token

  # GET /installations
  # GET /installations.xml
  def index
    @installations = website.brand.installations.order(:title)
  end

  # GET /installations/1
  # GET /installations/1.xml
  def show
    respond_to do |format|
      format.html {
        if !@installation.layout_class.blank? && File.exists?(Rails.root.join("app", "views", website.folder, "installations", "#{@installation.layout_class}.html.erb"))
          render template: "#{website.folder}/installations/#{@installation.layout_class}", layout: set_layout
        else
          render_template
        end
      }
      format.xml  { render xml: @installation }
    end
  end

  # /solutions Added for BSS,Crown 6/2015
  def solutions
    @hide_main_container = true
    render_template
  end

  private

  def load_and_authorize_installation
    if params[:id]
      @installation = Installation.find(params[:id])
      if !website.installations.include?(@installation)
        error_installation(404)
      end
    end
  end

end
