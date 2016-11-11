class SolutionsController < ApplicationController
  before_filter :set_locale

  def index
  end

  def show
    @solution = Solution.find(params[:id])
  end
end
