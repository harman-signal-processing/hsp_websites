namespace :reports do

  desc "Sends download totals for a given Software"
  task software_downloads: :environment do
    SoftwareReport.find_each do |software_report|
      software_report.send_monthly_report
    end
  end
  
  desc "Export product data for use with Etilize service"
  task etilize: :environment do
    fn = Rails.root.join("tmp", "etilize_#{Date.today.to_s}.xls")
    @user = User.new
    @ability = Ability.new(@user)
    
    Spreadsheet.client_encoding = "UTF-8"
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet

    sheet.row(0).default_format = Spreadsheet::Format.new( weight: :bold )
    sheet.row(0).height = 30
    sheet[0,0] = "Manufacturer Name"
    sheet[0,1] = "Brand Name"
    sheet[0,2] = "Manufacturer Partno"
    sheet[0,3] = "UPC"
    sheet[0,4] = "Product Identifiers"
    sheet[0,5] = "Category Name"
    sheet[0,6] = "Product Condition"
    sheet[0,7] = "Product Name"
    sheet[0,8] = "Product Title (Short/Main Description)"
    sheet[0,9] = "Product Sub-Title (Long/Technical Description)"
    sheet[0,10] = "Marketing Text"
    sheet[0,11] = "Key Selling Features"
    sheet[0,12] = "Main Image URL (High Quality)"
    sheet[0,13] = "Product Video/Tour URL"
    sheet[0,14] = "Additional Images/PDFs URLs"
    sheet[0,15] = "Attribute Name Values"
    
    wrapped = Spreadsheet::Format.new(text_wrap: true, vertical_align: :top)
    sheet.column(0).width = 20
    sheet.column(1).width = 15
    sheet.column(2).width = 15
    sheet.column(3).width = 15
    sheet.column(4).width = 20
    sheet.column(5).width = 15
    sheet.column(6).width = 10
    sheet.column(7).width = 20
    sheet.column(8).width = 30
    sheet.column(9).width = 35
    sheet.column(10).width = 50
    sheet.column(11).width = 50
    sheet.column(12).width = 80
    sheet.column(13).width = 10
    sheet.column(14).width = 100
    sheet.column(15).width = 80
    
    brand_categories = {
      martin: "lighting",
      amx: "video and control"
    }
    products_finished = []
    
    row = 0
    Brand.where(live_on_this_platform: true).each do |brand|
      brand_category = brand_categories.keys.include?(brand.name.to_sym) ? brand_categories[brand.name.to_sym] : "Pro Audio"
      
      brand.current_products.find_each do |product|
        next if products_finished.include?(product.to_param)
        next if product.name.to_s.match?(/China|\(CN/i)
        next if product.product_families.pluck(:name).join(" ").to_s.match?(/China|\(CN/i)
        next if product.name.to_s.match?(/\(EU/i)
        category_name = product.product_families.size > 0 ? product.product_families.first.name : brand_category
        product_brand = product.brand.live_on_this_platform? ? product.brand.name : brand.name
        product_photo = product.photo ? product.photo.product_attachment.url : ""
        
        additional_downloads = []
        (product.images_for("product_page") - [product.photo]).each_with_index do |product_attachment,i|
          unless product_attachment.hide_from_product_page? || product_attachment.product_media_thumb_file_name.present?
            additional_downloads << "Image#{i+2}|#{product_attachment.product_attachment.url}"
          end
        end
        product.safety_documents.each do |product_document|
          additional_downloads << formatted_item(product_document)
        end
        product.nonsafety_documents.each do |product_document|
          additional_downloads << formatted_item(product_document)
        end
        product.viewable_site_elements.each do |site_element|
          additional_downloads << formatted_item(site_element)
        end
        additional_downloads.compact!
        
        specs = []
        product.product_specifications.each do |spec|
          specs << "#{spec.specification.name_with_group}|#{spec.value}"
        end
        
        row += 1
        sheet[row,0] = "Harman International"
        sheet[row,1] = product_brand
        sheet[row,2] = product.sap_sku
        #sheet[row,3] = UPC
        sheet[row,4] = "harman_web_id|#{product.to_param}"
        sheet[row,5] = category_name
        sheet[row,6] = "New"
        sheet[row,7] = product.name
        sheet[row,8] = product.short_description
        #sheet[row,9] = subtitle long/technical description
        sheet[row,10] = product.description
        sheet[row,11] = product.features
        sheet[row,12] = product_photo
        #sheet[row,13] = product video/tour url
        sheet[row,14] = additional_downloads.join("\n")
        sheet[row,15] = specs.join("\n")
        if additional_downloads.size > 0
          sheet.row(row).height = additional_downloads.size * 20
        end
        (0..15).each { |c| sheet.row(row).set_format(c, wrapped) }
        
        products_finished << product.to_param
      end
    end
    
    book.write(fn)
    
  end

  def formatted_item(item)
    if @ability.can?(:read, item)
      if item.is_a?(SiteElement) && item.is_document?
        unless item.external_url.present? || item.executable_file_name.present?
          return "#{item.name}|#{item.resource.url}"
        end
      elsif item.is_a?(ProductDocument)
        return "#{item.name}|#{item.document.url}"
      end
    end
    nil
  end
  
end
