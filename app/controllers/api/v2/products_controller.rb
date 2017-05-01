# Note: v2 of the api is open to all without restriction and is a basic product catalog

module Api
  module V2
    class ProductsController < ApplicationController
      before_action :set_brand
      respond_to :xml, :json, :html

      def index
        @products = @brand.current_products.order(:name)
        respond_with @products
      end

      def show
        @product = Product.find(params[:id])
        if @product.show_on_website?(@brand.default_website)
          respond_with @product
        else
          respond_with Product.new
        end
      end

      private

      def set_brand
        @brand = Brand.find(params[:brand_id])
      end

    end
  end
end

