# Note: v2 of the api is open to all without restriction and is a basic product catalog

module Api
  module V2
    class ProductsController < ApplicationController
      skip_before_filter :miniprofiler
      respond_to :xml
      
      # def index
      #   @products = Product.all
      #   respond_with @products
      # end

      def show
        @product = Product.find(params[:id])
        respond_with @product
      end
      
      # def create
      #   @product = Product.create(params[:product])
      #   respond_with @product
      # end
      
      # def update
      #   @product = Product.update(params[:id], params[:products])
      #   respond_with @product
      # end
      
      # def destroy
      #   @product = Product.destroy(params[:id])
      #   respond_with @product
      # end

    end
  end
end

