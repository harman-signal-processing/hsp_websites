class ToolkitController < ApplicationController
  layout "toolkit"
  skip_before_filter :miniprofiler
  #before_filter :authenticate_user!
  
  def index
  end

  private

  # used as a before filter in the child controllers
  def load_brand
  	@brand = Brand.find(params[:brand_id])
  end
end
