module Api
  module V1
    class ProductFamiliesController < ApplicationController
      before_action :restrict_api_access
      respond_to :json, :xml

      def index
        @product_families = ProductFamily.all
        respond_with @product_families
      end

      def show
        @product_family = ProductFamily.find(params[:id])
        respond_with @product_family
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

