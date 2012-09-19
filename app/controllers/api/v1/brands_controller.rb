module Api
  module V1
    class BrandsController < ApplicationController
      before_filter :restrict_api_access
      respond_to :json
      
      def index
        respond_with Brand.all
      end
      
      def show
        respond_with Brand.find(params[:id])
      end
      
      def create
        respond_with Brand.create(params[:brand])
      end
      
      def update
        respond_with Brand.update(params[:id], params[:brands])
      end
      
      def destroy
        respond_with Brand.destroy(params[:id])
      end

    end
  end
end

# Dev key:
# 24da1c61be36b0090eb17f64b3a0b925