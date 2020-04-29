class CaseStudiesController < ApplicationController
  before_action :set_locale

  def index
      @case_studies = CaseStudyService.get_case_study_item_list_from_cache(website.brand.name.downcase)
    #   binding.pry
  end
  
  def show
      case_study_slug = params[:slug]
      case_studies = CaseStudyService.get_case_study_item_list_from_cache(website.brand.name.downcase)
      # @case_study = case_studies.select {|cs| cs[:slug] == case_study_slug}.first
      @case_study = case_studies.find {|cs| cs[:slug] == case_study_slug}
      @case_study_translation = @case_study[:translations].find{|t| t[:locale] == I18n.locale}
      # binding.pry
  end
  
  private
  
  def get_vertical_market_list(case_studies)
    
  end  #  def get_vertical_market_list(case_studies)
  
end  #  class CaseStudiesController < ApplicationController
  