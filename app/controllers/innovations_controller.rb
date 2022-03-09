class InnovationsController < ApplicationController
  before_action :load_and_authorize_innovation, only: :show
  skip_before_action :verify_authenticity_token

  # GET /innovations
  # GET /innovations.xml
  def index
    @innovations = website.brand.innovations.order(:position)
    render_template
  end

  # GET /innovations/1
  # GET /innovations/1.xml
  def show
    respond_to do |format|
      format.html { render_template }
      format.xml  { render xml: @innovation }
    end
  end

  private

  def load_and_authorize_innovation
    if params[:id]
      @innovation = Innovation.find(params[:id])
      if !website.brand.innovations.include?(@innovation)
        redirect_to root_path and return false
      end
    end
  end

end
