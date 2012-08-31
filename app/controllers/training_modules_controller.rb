class TrainingModulesController < ApplicationController

  def show
	@training_module = TrainingModule.find(params[:id])
	@page_title = @training_module.name
	render_template	
  end

end
