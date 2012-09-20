module Api
  module V1
    class BrandsController < ApplicationController
      before_filter :restrict_api_access
      respond_to :json
      
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
