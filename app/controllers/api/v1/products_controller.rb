module Api
  module V1
    class ProductsController < ApplicationController
      before_filter :restrict_api_access
      respond_to :json
      
      def index
        respond_with Product.all
      end
      
      def show
        respond_with Product.find(params[:id])
      end
      
      def create
        respond_with Product.create(params[:product])
      end
      
      def update
        respond_with Product.update(params[:id], params[:products])
      end
      
      def destroy
        respond_with Product.destroy(params[:id])
      end

    end
  end
end

# Dev key:
# 24da1c61be36b0090eb17f64b3a0b925