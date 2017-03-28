class SolutionsController < ApplicationController
  before_action :set_locale

  def index
  end

  def show
    @solution = Solution.find(params[:id])
  end
end
