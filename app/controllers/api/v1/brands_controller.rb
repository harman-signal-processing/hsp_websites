module Api
  module V1
    class BrandsController < ApplicationController
      skip_before_filter :miniprofiler
      before_filter :restrict_api_access
      respond_to :json, :xml
      
      def index
        @brands = Brand.all
        respond_with @brands
      end

      def for_employee_store
        @brands = Brand.for_employee_store
        respond_with @brands
      end
      
      def show
        @brand = Brand.find(params[:id])
        respond_with @brand
      end

      def service_centers
        @brand = Brand.find(params[:id])
        brand_id = @brand.service_centers_from_brand_id || @brand.id
        @service_centers = ServiceCenter.where(brand_id: brand_id)
        respond_with @service_centers
      end
      
      # def create
      #   @brand = Brand.create(params[:brand])
      #   respond_with @brand
      # end
      
      # def update
      #   @brand = Brand.update(params[:id], params[:brands])
      #   respond_with @brand
      # end
      
      # def destroy
      #   @brand = Brand.destroy(params[:id])
      #   respond_with @brand
      # end

    end
  end
end
