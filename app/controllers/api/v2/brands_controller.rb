# Note: v2 of the api is open to all without restriction and is a basic product catalog

module Api
  module V2
    class BrandsController < ApplicationController
      skip_before_filter :miniprofiler
      respond_to :xml
      
      def index
        @brands = Brand.all
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
