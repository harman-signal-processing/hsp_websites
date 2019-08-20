class TrainingController < ApplicationController

  # Routes to /:locale/training
  def index
    @page_title = "#{website.brand.name} Training"
    @product_training_modules = website.training_modules(module_type: 'product')
    @software_training_modules = website.training_modules(module_type: 'software')
    @training_courses = website.brand.training_courses
    @upcoming_classes = website.brand.upcoming_training_classes
    render_template
  end

end

