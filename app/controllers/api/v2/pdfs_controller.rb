module Api
  module V2
    class PdfsController < ApplicationController
      before_action :set_brand
      respond_to :xml, :json, :html, :text
      layout "minimal"

      def index
      	
      	product_document_pdfs = []
      	website.brand.products.each do |product|
          if !product.product_status.is_hidden?
            product_document_pdfs << product.product_documents.where("document_file_name like ?","%.pdf%")
          end
      	end
        site_element_pdfs = website.brand.site_elements.where("resource_file_name like ? or executable_file_name like ?","%.pdf%","%.pdf%")
        product_documents_and_site_element_pdfs = product_document_pdfs.flatten + site_element_pdfs.to_ary
        
        @pdfs = product_documents_and_site_element_pdfs.map {|item|
          if item.present? && item.show_on_public_site
            case item.class.name
              when "ProductDocument"
                {name:item.name,url:item.url}
              when "SiteElement"
                {name:item.long_name,url:item.url}
              else
            end
          end
        }
        respond_with @pdfs.uniq
      end


      private

      def set_brand
        @brand = Brand.find(params[:brand_id])
      end

    end
  end
end
