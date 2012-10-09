class ToolkitController < ApplicationController
  layout "toolkit"
  skip_before_filter :miniprofiler
  before_filter :authenticate_user!
  
  def index
  	@brands = Brand.all
  end
end
