module WaveReport

  def wave_report(website)
    xls_report = StringIO.new
    Spreadsheet.client_encoding = "UTF-8"
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet

    sheet.row(0).default_format = Spreadsheet::Format.new( weight: :bold )
    sheet.row(0).height = 30
    sheet[0,0] = "Vendor Name"
    sheet[0,1] = "Manufacturer SKU"
    sheet[0,2] = "Product Title"
    sheet[0,3] = "Item UPC"
    sheet[0,4] = "Product Cost (USD)"
    sheet[0,5] = "MSRP (USD)"
    sheet[0,6] = "Product Weight"
    sheet[0,7] = "Product Dimensions (LxWxH)"
    sheet[0,8] = "Shipping Weight"
    sheet[0,9] = "Shipping Dimensions (LxWxH)"
    sheet[0,10] = "What's in the box"
    sheet[0,11] = "Product Description"
    sheet[0,12] = "Specifications"
    sheet[0,13] = "Main Image (URL)"
    sheet[0,14] = "Additional Images (URL)"
    sheet[0,15] = "Spec Sheet (URL)"
    sheet[0,16] = "Video (URL)"
    sheet[0,17] = "Manual (URL)"

    sheet.column(0).width = 15
    sheet.column(1).width = 15
    sheet.column(2).width = 30
    sheet.column(3).width = 15
    sheet.column(4).width = 15
    sheet.column(5).width = 15
    sheet.column(6).width = 15
    sheet.column(7).width = 40
    sheet.column(8).width = 15
    sheet.column(9).width = 35
    sheet.column(10).width = 20
    sheet.column(11).width = 50
    sheet.column(12).width = 50
    sheet.column(13).width = 50
    sheet.column(14).width = 50
    sheet.column(15).width = 50
    sheet.column(16).width = 50
    sheet.column(17).width = 50

    products_for_wave_report(website).each_with_index do |product,i|
      next unless product.brand_id == website.brand_id
      row = i + 1
      sheet[row,0] = product.brand.name
      sheet[row,1] = product.sap_sku
      sheet[row,2] = product.name
      #sheet[row,3] = ""
      #sheet[row,4] = ""
      sheet[row,5] = product.msrp
      sheet[row,6] = product.best_guess_spec_value("weight")
      sheet[row,7] = product.best_guess_spec_value("dimensions")
      sheet[row,8] = product.best_guess_spec_value("shipping_weight")
      sheet[row,9] = product.best_guess_spec_value("shipping_dimensions")
      #sheet[row,10] = "" # We don't track 'whats in the box'
      sheet[row,11] = product.description
      sheet[row,12] = product.product_specifications.map{|ps| "#{ps.specification.name}: #{ps.value}"}.join("\n")
      if product.photo
        sheet[row,13] = product.photo.product_attachment.url
      end
      sheet[row,14] = product.images_for(:product_page).map{|i| i.product_attachment.url}.join("\n")
      sheet[row,15] = product.spec_sheets.join("\n")
      if product.product_videos.length > 0
        sheet[row,16] = product.product_videos.first.url
      end
      sheet[row,17] = product.user_guides.join("\n")
    end

    book.write(xls_report)
    xls_report.string
  end

  def products_for_wave_report(website)
    #I18n.locale = "en-US"
    case
    when respond_to?(:current_products_plus_child_products)
      current_products_plus_child_products(website).select{|p| p if p.brand_id == website.brand_id}
    when respond_to?(:current_products)
      current_products.select{|p| p if p.brand_id == website.brand_id}
    when respond_to?(:products)
      products
    end
  end

end
