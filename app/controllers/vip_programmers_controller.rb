class VipProgrammersController < ApplicationController
  def index
    # These are for building the filters the user will use on the page
    @all_global_regions = Vip::GlobalRegion.all.order(:name)
    @all_categories = Vip::ServiceCategory.all.order(:name)
    @all_certifications = Vip::Certification.all.order(:name)
    @all_trainings = Vip::Training.all.order(:name)
    @all_services = Vip::Service.all.order(:name)
    @all_skills = Vip::Skill.all.order(:name)
    @all_markets = Vip::Market.all.order(:name)
    
    # Parameters the user selected to filter the list
    @region = params[:region]
    @service_category = params[:service_category]
    @certification = params[:certification]
    @training = params[:training]
    @service = params[:service]
    @skill = params[:skill]
    @market = params[:market]
    
    conditions_array = []
    conditions_array << {value: @region, has_many_symbol: :global_regions, column_name: "vip_global_regions.name"} unless @region.nil?
    conditions_array << {value: @service_category, has_many_symbol: :categories, column_name: "vip_service_categories.name"} unless @service_category.nil?
    conditions_array << {value: @certification, has_many_symbol: :certifications, column_name: "vip_certifications.name"} unless @certification.nil?
    conditions_array << {value: @training, has_many_symbol: :trainings, column_name: "vip_trainings.name"} unless @training.nil?
    conditions_array << {value: @service, has_many_symbol: :services, column_name: "vip_services.name"} unless @service.nil?
    conditions_array << {value: @skill, has_many_symbol: :skills, column_name: "vip_skills.name"} unless @skill.nil?
    conditions_array << {value: @market, has_many_symbol: :markets, column_name: "vip_markets.name"} unless @market.nil?

    # build the dynamic query values
    values_array = []
    joins_array = [:locations]
    column_name_array = []
    conditions_array.each do |condition|
      values_array << condition[:value]
      joins_array << condition[:has_many_symbol]
      column_name_array << condition[:column_name]
    end  #  conditions_array.each do |condition|
    
    # build where clause
    where_clause_columns = column_name_array.map{|column| column + " = ?"}.join(" and ")
    @programmers = Vip::Programmer.joins(joins_array).where("#{where_clause_columns}",*values_array).distinct.order(:name)
  end # def index

  def show
    @vip_programmer = Vip::Programmer.find(params[:id])
  end
end
