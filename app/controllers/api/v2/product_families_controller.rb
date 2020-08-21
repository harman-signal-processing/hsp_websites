module Api
  module V2
    class ProductFamiliesController < ApplicationController
      before_action :set_brand, :set_ability
      respond_to :xml, :json, :html

      def index
        @product_families = ProductFamily.all_parents(@brand).order(:name)
        respond_with @product_families
      end

      def show
        @product_family = ProductFamily.find(params[:id])
        respond_with @product_family
      end

      def wave
        fn_chunks = [@brand.to_param]
        if params[:id]
          product_family = ProductFamily.find(params[:id])
          report_data = product_family.wave_report(website)
          fn_chunks << product_family.to_param
        else
          report_data = @brand.wave_report(website)
        end
        fn_chunks += ["products", I18n.l(Date.today)]

        respond_to do |format|
          format.xls {
            send_data(
              report_data,
              filename: fn_chunks.join("_") + ".xls",
              type: "application/excel; charset=utf-8; header=present"
            )
          }
        end
      end

      private

      def set_brand
        @brand = Brand.find(params[:brand_id])
      end

      # Since V2 is wide open read-only, use the cancan ability for a non-authenticated user
      def set_ability
        @current_ability ||= Ability.new(User.new)
      end

    end
  end
end

