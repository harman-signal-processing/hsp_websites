# Note: v2 of the api is open to all without restriction and is a basic product catalog

module Api
  module V2
    class ProductsController < ApplicationController
      skip_before_filter :miniprofiler
      respond_to :xml

      def index
        @brand = Brand.find(params[:brand_id])
        @products = @brand.current_products
        respond_with @products
      end

      def show
        @product = Product.find(params[:id])
        respond_with @product
      end

    end
  end
end

