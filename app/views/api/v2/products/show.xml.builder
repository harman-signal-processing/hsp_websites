xml.instruct! :xml, version: "1.0"

xml.product name: @product.name do
    xml.link url: "http://#{@product.brand.default_website.url}#{url_for(@product)}"
    xml.brand @product.brand.name, api_url: api_v2_brand_url(@product.brand).gsub!(/\?.*$/, '')
    xml.brief @product.short_description, type: 'text'
    xml.description @product.description, type: 'html'
    if @product.extended_description.present?
        xml.tag! 'extended-description', @product.extended_description, type: 'html'
    end
    xml.features @product.features, type: 'html'

    xml.media do 
        @product.images_for("product_page").each do |product_attachment|
            url = product_attachment.product_attachment.url
            url = "http://#{request.host}#{url}" if HarmanSignalProcessingWebsite::Application.config.action_controller.asset_host.present?
            xml.item(
                url: url, 
                type: product_attachment.product_attachment_content_type,
                primary_photo: @product.photo && @product.photo == product_attachment
            )
        end
    end

    xml.documents do 
        @product.product_documents.includes(:product).each do |product_document|
            url = product_document.document.url
            url = "http://#{request.host}#{url}" if HarmanSignalProcessingWebsite::Application.config.action_controller.asset_host.present?
            xml.item(
                product_document.name(hide_product_name: true),
                url: url,
                type: product_document.document_content_type,
                doctype: I18n.t("document_type.#{product_document.document_type}"),
                size: product_document.document_file_size
            )
        end
        @product.viewable_site_elements.each do |site_element|
            url = site_element.resource.url
            url = "http://#{request.host}#{url}" if HarmanSignalProcessingWebsite::Application.config.action_controller.asset_host.present?
            xml.item(
                site_element.name,
                url: url,
                type: site_element.resource_content_type,
                doctype: site_element.resource_type,
                size: site_element.resource_file_size
            )
        end
    end

    xml.downloads do
        @product.active_softwares.each do |software|
            xml.item(
                software.formatted_name,
                url: "http://#{@product.brand.default_website.url}#{url_for(software)}",
                type: software.ware_content_type,
                size: software.ware_file_size
            )
        end
        @product.executable_site_elements.each do |site_element| 
            url = site_element.executable.url
            url = "http://#{request.host}#{url}" if HarmanSignalProcessingWebsite::Application.config.action_controller.asset_host.present?
            xml.item(
                site_element.name,
                url: url,
                type: site_element.executable_content_type,
                doctype: site_element.executable_type,
                size: site_element.executable_file_size
            )
        end
    end

    xml.specifications do 
        @product.product_specifications.includes(:specification).each do |product_spec|
            xml.item(
                name: product_spec.specification.name,
                value: product_spec.value
            )
        end
    end

end
