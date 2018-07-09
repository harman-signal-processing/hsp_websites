namespace :martin do

  desc "Slurp up all the martin parts"
  task import_parts: :environment do

    @root_site = "http://www.martin.com"
    martin = Brand.find "martin"
    problems = []
    successes = []

    @agent = Mechanize.new
    logged_in_page = login_to_support_page
    products = Product.where(brand: martin)
    #products = load_mismatches
    products += load_the_problematic_ones("Discontinued")
    #products = Product.where(name: "Mac Viper Performance")

    #to_be_deleted = ProductStatus.where(name: "_delete").first_or_create
    if logged_in_page.code == "200"
      puts "Logged in."
      products.each do |product|
        puts "Getting #{ product.name }"
        next if product.product_parts.where(parent_id: -1).count > 0
        begin
          friendly_id = product.old_id.present? ? product.old_id : product.friendly_id
          if friendly_id.to_s.match(/PROD/)
            page = @agent.get("#{ @root_site }/en-us/support/product-details?ProductID=#{ friendly_id }")
          else
            page = @agent.get("#{ @root_site }/en-us/support/product-details/#{ friendly_id }")
          end
          if page.code == "200"
            product_id = nil
            page_id = nil
            page.css('script').each do |script|
              if script.content.to_s.match(/var currentpageid = \'(\d{1,})\'/)
                page_id = $1
              end
              if script.content.to_s.match(/var currentproductid = \'(\d{1,})\'/)
                product_id = $1
              end
            end
            puts "  determined (old) product ID: #{ product_id.to_s }"
            ProductPart.where(product_id: product.id).where("parent_id IS NULL or parent_id = 0").update_all(parent_id: -1)
            page.css("div#sparepartListTree").css('div.bomitem').each do |bomitem|
              parse_bomitem(bomitem, product, product_id, page_id, false)
            end
            successes << product
          else
    #        product.update_column(:product_status_id, to_be_deleted.id)
            puts "  well that didn't work."
            problems << product
          end
        rescue
          #product.update_column(:product_status_id, to_be_deleted.id)
          puts "  well that didn't work."
          problems << product
        end
      end
    end

    puts "Problems:"
    puts "============================="
    problems.each do |product|
      puts "    #{product.name}"
    end
    puts "============================="
    puts "Problems: #{ problems.length }"
    puts "Successes: #{ successes.length }"
  end

  desc "Create missing Martin products"
  task create_products: :environment do
    martin = Brand.find "martin"
    discontinued = ProductStatus.where(name: "Discontinued").first_or_create
    imported = ProductStatus.where(name: "_Imported").first_or_create
    new_products = []

    csv_file = File.join(Rails.root, "db", "productnames.csv")
    CSV.foreach(csv_file, encoding: 'ISO-8859-1', headers: true).each do |row|
      # Need to downcase the "name" then search for the cached slug first
      probable_id = row["ProductName"].downcase.gsub(/\-{1,}/, "-").gsub(/\_/, "-")
      product_name = row["ProductName"].gsub(/\-{1,}/, "-").gsub(/\-|\_/, " ")

      next if product_name.match(/printed|copy|test|swag/i)
      next if new_products.include?(probable_id)

      if Product.exists?(probable_id)
        product = Product.find(probable_id)
        unless product.brand == martin
          product = Product.where(name: product_name, brand: martin).first_or_initialize
        end
      else
        product = Product.where(name: product_name, brand: martin).first_or_initialize
      end

      next unless product.new_record?
      product.cached_slug = row["ProductName"].downcase

      product.product_status = imported
      if row["ProductDiscontinued"].to_i == 1
        product.product_status = discontinued
      end

      product.layout_class = "vertical"
      product.extended_description_tab_name = "Tech Specs"
      product.hide_buy_it_now_button = true

      puts "Creating product #{ product.name } (#{ product.product_status.name })"
      new_products << probable_id
      product.save
    end

    puts "================================="
    puts "New products: #{ new_products.count }"
  end

  def parse_bomitem(bomitem, product, product_id, page_id, parent)
    new_product_part = find_or_create_part(bomitem, product, parent)

    if bomitem.search('a.showbomitems') # this has children
      child_url = "#{ @root_site }/Martin.Ajax.aspx?cmd=sp:getbomitems&bomid=#{ new_product_part.part.part_number }&pageid=#{ page_id.to_s }&productid=#{ product_id.to_s }"
      ajax = @agent.get(child_url)
      ajax.css('div.bomitem').each do |thisbomitem|
        parse_bomitem(thisbomitem, product, product_id, page_id, new_product_part)
      end
    end
  end

  def find_or_create_part(bomitem, product, parent)
    part_number = ""
    description = ""
    if bomitem.css('a.showbomitems').length > 0
      part_number = bomitem.css('a.showbomitems')[0]["data-bomid"]
      begin
        if bomitem.css('div.product').length > 0
          if bomitem.css('div.product')[0].css('span').length > 0
            description = bomitem.css('div.product')[0].css('span').last.content.strip
          else
            description = bomitem.css('div.product')[0].css('b').last.content.strip
          end
          if description.blank?
            puts "WHY CAN'T I GET THIS DESCRIPTION?!?!??!"
            description = bomitem.css('div.product')[0].content.strip.gsub(/#{ part_number }/, "").strip
            puts "----------> found this: #{ description }"
          end
        elsif bomitem.css('div.group1').length > 0
          description = bomitem.css('div.group1')[0].text.strip
        end
      rescue
        puts "Couldn't find a description for #{ part_number }"
      end
    else
      part_number = bomitem.css('div.product')[0]["data-bomid"]
      begin
        description = bomitem.css('div.product')[0].children.last.text.strip
      rescue
        puts "Couldn't find a description for #{ part_number }"
      end
    end

    if part_number.blank?
      puts "  **************** skipping blank part number"
    else
      part = Part.where(part_number: part_number).first_or_initialize
      part.description = description unless part.description.present?
      #part.parent ||= parent

      if part.photo.blank?
        img_url = "#{ @root_site }/files/images/products/#{ part_number }.jpg"
        puts "Getting: #{img_url}"
        begin
          if @agent.get(img_url).save("tmp/#{ part_number }.jpg")
            img = File.open("tmp/#{ part_number }.jpg")
            part.photo = img
            img.close
          end
        rescue
          puts "...couldn't get the image directly. Oh well."
        end
      end

      if part.photo.blank? #(still)
        img_url = "#{ @root_site }/admin/public/getimage.ashx?Image=/files/images/products/#{ part_number }.jpg&width=100&Compression=90&Format=jpg"
        puts "Getting: #{img_url}"
        begin
          if @agent.get(img_url).save("tmp/#{ part_number }.jpg")
            img = File.open("tmp/#{ part_number }.jpg")
            part.photo = img
            img.close
          end
        rescue
          puts "...couldn't get the image with the admin utility. Oh well."
        end
      end

      part.save
      puts "Created/updated part #{ part.part_number } desc: #{ part.description }"
      parent_id = parent.present? ? parent.id : nil
      ProductPart.where(product_id: product.id, part_id: part.id, parent_id: parent_id).first_or_create
    end
  end

  desc "Add descriptions, etc. to martin products"
  task add_content: :environment do

    @root_site = "http://www.martin.com"
    martin = Brand.find "martin"
    problems = []
    successes = []

    @agent = Mechanize.new

    products = []
    #products = Product.where(brand: martin).where("created_at > ?", "2018-05-08".to_time).where("product_status_id != 7")
    #products = Product.where(brand: martin).where(product_status: ProductStatus.where(name: "Discontinued").first)
    #["fog", "haze", "low-fog", "fluid"].each do |k|
    #  pf = ProductFamily.find k
    #  products += pf.products
    #end
    #products = load_mismatches
    products += load_the_problematic_ones("_delete")

    products.each do |product|
      puts "Getting #{ product.name }"
      begin
        friendly_id = product.old_id.present? ? product.old_id : product.friendly_id
        puts "Loading page for #{ friendly_id }"
        if friendly_id.to_s.match?(/PROD/i)
          page = @agent.get("#{ @root_site }/en-us/product-details?ProductID=#{ friendly_id }")
        else
          page = @agent.get("#{ @root_site }/en-us/product-details/#{ friendly_id }")
        end
        if page.code == "200"
          add_descriptions_to_product(product, page)
          add_gallery_to_product(product, page)
          add_main_image(product, page)
          add_specs_to_product(product, page)
          successes << product
        else
          puts "  well that didn't work."
          problems << product
        end
      rescue
        puts "  well that didn't work."
        problems << product
      end
    end

    puts "Problems:"
    puts "============================="
    problems.each do |product|
      puts "    #{product.name}"
    end
    puts "============================="
    puts "Problems: #{ problems.length }"
    puts "Successes: #{ successes.length }"

  end

  desc "Add gated content to martin products"
  task add_gated_content: :environment do

    @root_site = "http://www.martin.com"
    martin = Brand.find "martin"
    problems = []
    successes = []
    @software_pages = []

    @agent = Mechanize.new
    logged_in_page = login_to_support_page()

    #products = Product.where(brand: martin).where("product_status_id != 7").limit(999)
    #products = load_mismatches
    #products = Product.where(brand: martin).where(product_status: ProductStatus.where(name: "Discontinued").first)
    #products += load_the_problematic_ones("Discontinued")
    products = Product.where(name: "RUSH MH 11 Beam")

    if logged_in_page.code == "200"
      products.each do |product|
        puts "Getting #{ product.name }"
        begin
          friendly_id = product.old_id.present? ? product.old_id : product.friendly_id
          if friendly_id.to_s.match(/PROD/)
            page = @agent.get("#{ @root_site }/en-us/support/product-details?ProductID=#{ friendly_id }")
          else
            page = @agent.get("#{ @root_site }/en-us/support/product-details/#{ friendly_id }")
          end
          if page.code == "200"
            add_downloads_to_product(product, page)
            successes << product
          else
            puts "  well that didn't work."
            problems << product
          end
        rescue
          puts "  well that didn't work."
          problems << product
        end
      end
    end

    #puts "Problems:"
    #puts "============================="
    #problems.each do |product|
    #  puts "    #{product.name}"
    #end
    #puts "============================="
    #puts "Problems: #{ problems.length }"
    #puts "Successes: #{ successes.length }"
    puts "============================"
    puts " Software to be uploaded: "
    @software_pages.each do |s|
      puts s.to_param
    end
  end

  def add_downloads_to_product(product, page)
    page.css("table.Prod_Documentlist tbody tr").each do |row|
      begin
        fields = {}
        cells = row.css("td")
        if cells[4].content.to_s.match(/html|link/i) && cells[6].content.to_s.match?(/software/i)
          if product.softwares.length == 0
            @software_pages << product unless @software_pages.include?(product)
          end
        else
          thelink = cells[0].css("a")[0]
          file_url = thelink["href"]
          fn = file_url.split(/\//).last
          fields[:name] = thelink.content.strip

          security_level = thelink["class"].gsub(/level/, "")
          unless security_level == "999"
            access_level = AccessLevel.where(name: security_level).first_or_create
            fields[:access_level_id] = access_level.id
          end
          fields[:version] = cells[1].content.strip
          fields[:language] = cells[2]["data-sort"].downcase
          fields[:created_at] = cells[5]["data-sort"].to_time
          fields[:resource_type] = cells[6].content.strip.titleize
          fields[:brand_id] = product.brand_id
          fields[:show_on_public_site] = true
          fields[:is_document] = true

          #unless security_level == "999" || security_level == "100" || security_level == "200"
            #puts "  Found: #{ fields.inspect }, url: #{ file_url }"
            add_downloads_part_two(product, fields, file_url, fn)
          #end
        end
      rescue
        puts "....Problem with #{ row.inspect }"
      end
    end
  end

  def add_downloads_part_two(product, fields, file_url, fn)
    #the_stored_fn = fn.gsub(/(\.\w*)$/, "_original"+'/1')
    the_stored_fn = fn.gsub(/\s/, "_")
    #the_stored_fn = Paperclip::Interpolations.interpolate(":basename.:extension", attachment, :original)
    if !!(fn.match(/(png|jpg|jpeg|tif|tiff|bmp|gif)$/i))
      se = SiteElement.where(
        brand_id: fields[:brand_id],
        name: fields[:name],
        version: fields[:version],
        language: fields[:language],
        resource_file_name: the_stored_fn
      ).first_or_initialize
    else
      se = SiteElement.where(
        brand_id: fields[:brand_id],
        name: fields[:name],
        version: fields[:version],
        language: fields[:language],
        executable_file_name: the_stored_fn
      ).first_or_initialize
    end

    if se.new_record?
      #puts "This would be a new record: #{ se.inspect } (original fn: #{fn})"
      fields.each do |k,v|
        se[k] = v
      end
      if @agent.get(file_url).save("tmp/#{fn}")
        download = File.open("tmp/#{fn}")
        if !!(fn.match(/(png|jpg|jpeg|tif|tiff|bmp|gif)$/i))
          se.resource = download
        else
          se.executable = download
        end
        download.close
#        se.save
        File.delete("tmp/#{fn}")
      else
        puts "   ERROR getting #{file_url }"
      end
    else
      if se.access_level_id != fields[:access_level_id]
        #fields[:access_level_id] = AccessLevel.where(name: "300").first_or_create.id
      end
    end

    se.update_attributes(fields)

    ProductSiteElement.where(product: product, site_element: se).first_or_create
  end

  def add_descriptions_to_product(product, page)
    puts "Updating description..."
    new_description = ""
    begin
      new_description = page.css(".prodDescription")[0].css(".prodDesc")[0].inner_html.strip
      if page.css("#prodSellingPoints").length > 0
        new_description += page.css("#prodSellingPoints")[0].inner_html.strip
      end
    rescue
      puts "Problem adding description"
    end
    if product.description.blank? && !new_description.blank?
      product.description = new_description
    end

    puts "Updating features..."
    new_features = ""
    begin
      new_features = page.css("#features .infoBox")[0].inner_html.strip
    rescue
      puts "Problem adding features"
    end
    if product.features.blank? && !new_features.blank?
      product.features = new_features
    end
    product.save
  end

  def add_gallery_to_product(product, page)
    puts "Scanning the gallery..."
    page.css("ul#listGallery li").each do |gallery_item|
      thelink = gallery_item.css("a")[0]
      if thelink["href"].to_s.match(/youtube\.com\/embed\/(.*)\?+/)
        # add a video
        pv = ProductVideo.where(product_id: product.id, youtube_id: $1, group: "Product Demos").first_or_create
        puts " ... adding video #{ pv.youtube_id }"
      else
        img_url = thelink["href"]
        fn = img_url.split(/\//).last
        puts " ... getting image #{ fn }"
        unless product.product_attachments.pluck(:product_attachment_file_name).include?(fn)
          begin
            add_one_image_to_product(product, img_url, fn)
          rescue
            puts "Problem adding img #{ img_url } to #{ product.name }"
          end
        end
      end
    end
    product.save
  end

  def add_main_image(product, page)
    if product.product_attachments.length == 0
      if page.css("#prodTop").css("img.img-responsive").length > 0
        img_url = page.css("#prodTop").css("img.img-responsive")[0]["src"]
        if img_url.to_s.match(/Image\=\/Files\/images\/Products\/(.*)\/&+/)
          fn = $1
        else
          fn = "#{product.name.parameterize}.jpg"
        end
        puts " ...getting #{ fn }"
        add_one_image_to_product(product, img_url, fn)
      end
    end
  end

  def add_one_image_to_product(product, img_url, fn)
    if @agent.get(img_url).save("tmp/#{fn}")
      img = File.open("tmp/#{fn}")
      product.product_attachments << ProductAttachment.new(product_attachment: img)
      img.close
      product.save
      File.delete("tmp/#{fn}")
    end
  end

  def add_specs_to_product(product, page)
    if product.extended_description.blank?
      puts "Updating specs..."
      new_images = {
        "CE" => "/resource/martin-ce-mark.png",
        "ETL C US Intertek" => "/resource/martin-etl-mark.png",
        "C-Tick" => "/resource/martin-c-tick-mark.png",
        "Aus" => "/resource/rcm-mark.png",
        "IK08" => "/resource/ik08-mark.png",
        "UL C US" => "/resource/martin-ul-mark.jpg"
      }
      begin
        approvals = []
        if page.css("#techSpecs .approval").length > 0
          page.css("#techSpecs .approval")[0].css("img").each do |appr_img|
            approvals << appr_img["title"]
          end
        end

        tech_specs = '<div class="row">'
        tech_specs += '<div class="small-12 medium-6 columns">'
        tech_specs += page.css("#techSpecs .specsCol1")[0].inner_html.strip
        tech_specs += '</div><div class="small-12 medium-6 columns">'

        page.css("#techSpecs .specsCol2")[0].css("div.spec").each do |spec|
          tech_specs += '<div class="spec">' + spec.inner_html.strip
          if spec.content.to_s.match(/Approvals/)
            tech_specs += '<div class="spec approval">'
              approvals.each do |approval|
                if new_images.keys.include?(approval)
                  tech_specs += "<img src=\"#{new_images[approval]}\" alt=\"#{ approval }\" title=\"#{ approval }\"/>&nbsp;"
                else
                  tech_specs += "<span class=\"missing-mark\">#{ approval }</span>&nbsp;"
                end
              end
            tech_specs += '</div>'
          end
          tech_specs += '</div>'
        end
        tech_specs += '</div>'
        tech_specs += '</div>'

        product.extended_description = tech_specs
      rescue
        puts "Problem adding tech specs"
      end
      product.save
    else
      puts "Skipping specs (already present)"
    end
  end

  def load_mismatches
    p = []
    csv_file = File.join(Rails.root, "db", "martin-mismatches.csv")
    CSV.foreach(csv_file, encoding: 'ISO-8859-1', headers: true).each do |row|
      next unless row["new_id"].present?
      product = Product.find(row["new_id"])
      product.old_id = row["old_id"]
      p << product
    end
    p
  end

  def load_the_problematic_ones(product_status_name)
    products = []
    scanned_prod_ids = []
    product_status = ProductStatus.where(name: product_status_name).first
    martin = Brand.find "martin"
    csv_file = File.join(Rails.root, "db", "productnames.csv")
    CSV.foreach(csv_file, encoding: 'ISO-8859-1', headers: true).each do |row|
      next if scanned_prod_ids.include?(row["ProductID"])
      scanned_prod_ids << row["ProductID"]
      next if row["ProductName"].to_s.match?(/test|printed|swag|copy/i)
      probable_id = row["ProductName"].downcase.gsub(/\+/, "-plus").gsub(/\#|\*|\(|\)/, "").gsub(/\_|¥/, "-").gsub(/\-{1,}/, "-")
      probable_id.gsub!(/\-*$/, "")
      probable_id.gsub!(/ð/, "d")
      probable_id.gsub!(/\&\-/, "")
      if probable_id == "edit"
        probable_id = "martin-edit"
      end
      next if probable_id == "exterior-400-image-projector"
      begin
        product = Product.find(probable_id)
        if product.product_status == product_status && product.brand == martin
          product.old_id = row["ProductID"]
          products << product
          puts "Loaded #{ product.name }, old id: #{ product.old_id }"
        end
      rescue
        puts "Couldn't load #{probable_id}"
      end
    end
    products.uniq
  end

  def login_to_support_page(opts={})
    # Login to get gated content
    p = @agent.get("#{ @root_site }/support")
    login_form = p.form_with id: "ExtUserForm"
    login_form.Username = opts[:username] || ENV['MARTIN_ADMIN']
    login_form.Password = opts[:password] || ENV['MARTIN_PASSWORD']
    login_form.click_button
  end

  desc "Find all the missing HTML tech docs"
  task audit_content: :environment do

    @root_site = "http://www.martin.com"
    martin = Brand.find "martin"
    problems = []
    successes = []

    @agent = Mechanize.new
    login_to_support_page()

    #products = Product.where(brand: martin).where("product_status_id != 7").limit(999)
    #products = load_mismatches
    products = Product.where(brand: martin)
    products += load_the_problematic_ones("Discontinued")
    #products = Product.where(name: "RUSH MH 11 Beam")

    CSV.open("htmls.csv", "w") do |csv|
      csv << ["Product", "Resource Name", "Security", "Version", "Language", "Resource Type", "Created", "Link"]
      products.each do |product|
        puts "Getting #{ product.name }"
        begin
          friendly_id = product.old_id.present? ? product.old_id : product.friendly_id
          if friendly_id.to_s.match(/PROD/)
            page = @agent.get("#{ @root_site }/en-us/support/product-details?ProductID=#{ friendly_id }")
          else
            page = @agent.get("#{ @root_site }/en-us/support/product-details/#{ friendly_id }")
          end
          if page.code == "200"
            html_pages = get_htmls_for_product(product, page)
            html_pages.each do |html|
              csv << html
            end
            successes << product
          else
            puts "  well that didn't work."
            problems << product
          end
        rescue
          puts "  well that didn't work."
          problems << product
        end
      end
    end

    puts "wrote output lines to csv output"
  end

  def get_htmls_for_product(product, page)
    htmls = []
    page.css("table.Prod_Documentlist tbody tr").each do |row|
      begin
        fields = {}
        cells = row.css("td")
        thelink = cells[0].css("a")[0]
        file_url = thelink["href"]
        fields[:name] = thelink.content.strip
        security_level = thelink["class"].gsub(/level/, "")
        fields[:version] = cells[1].content.strip
        fields[:language] = cells[2]["data-sort"].downcase
        fields[:created_at] = cells[5]["data-sort"].to_time
        fields[:resource_type] = cells[6].content.strip.titleize
        fields[:brand_id] = product.brand_id
        fields[:show_on_public_site] = true
        fields[:is_document] = true
        if cells[4].content.to_s.match(/html|link/i)
          htmls << [
            product.to_param,
            fields[:name],
            security_level,
            fields[:version],
            fields[:language],
            fields[:resource_type],
            fields[:created_at],
            file_url
          ]
        end
      rescue
        #puts "....Problem with #{ row.inspect }"
      end
    end
    htmls
  end

  task pull_html: :environment do
    @root_site = "http://www.martin.com"
    martin = Brand.find "martin"
    problems = []
    successes = []

    @agent = Mechanize.new
    login_to_support_page()

    CSV.foreach("htmls.csv", headers: true) do |row|
      next if row["Resource Type"].to_s.match?(/software/i)

      if row["Link"].to_s.match(/\?file\=(.*\.html)\&+/)
        path = $1
      else
        path = row["Link"]
      end
      link = "#{@root_site}#{path}"
      if path.blank?
        puts " problem getting path from #{row['Link']}"
        problems << row["Link"]
      end

      row["Security"].to_s.match(/(\d{1,})/)
      security = $1
      se = SiteElement.where(source: link).first_or_initialize

      begin
        if se.new_record?
          # get it
          page = @agent.get(link)
          se.content = page.content
          se.name = row["Resource Name"]
          se.version = row["Version"]
          se.language = row["Language"]
          se.resource_type = row["Resource Type"]
          se.brand = martin
          se.created_at = row["Created"].to_time
          se.is_document = true
          se.show_on_public_site = true
        end

        if security.to_s == "999"
          se.access_level_id = nil
        else
          se.access_level = AccessLevel.where(name: security).first_or_create
        end

        product = Product.find(row["Product"])
        se.products << product unless se.products.include?(product)
        se.save
        #puts "Adding #{product.to_param} to #{ se.id }"
      rescue
        puts "  --> oops"
        problems << row["Link"]
      end

    end

    puts "Problems:"
    puts problems.inspect
  end

  desc "Move spec sheets to site resources"
  task move_spec_sheets: :environment do
    @agent = Mechanize.new
    martin = Brand.find "martin"
    martin.products.each do |product|
      puts "#{product.name}: "
      product.product_documents.where(document_type: "spec_sheet").each do |spec_sheet|

        se = SiteElement.where(
          name: spec_sheet.name(hide_language: true),
          brand_id: martin.id,
          language: spec_sheet.language,
          is_document: true,
          show_on_public_site: true,
          resource_type: "Specifications"
        ).first_or_initialize

        puts "  init: #{ se.name } (#{ se.new_record? ? 'new' : 'old' } record)"
        unless se.executable_file_name == spec_sheet.document_file_name
          puts "     downloading...#{ spec_sheet.document.url }"
          if @agent.get(spec_sheet.document.url).save("tmp/#{spec_sheet.document_file_name}")
            download = File.open("tmp/#{spec_sheet.document_file_name}")
            se.executable = download
            download.close
            se.save
            File.delete("tmp/#{spec_sheet.document_file_name}")
          else
            puts "   ERROR getting #{spec_sheet.document.url }"
          end
        end

        if se.new_record?
          puts " #*#*#*#*#*#* The SiteElement never got saved. #*#*#*#*#*#*#*#*#"
        else
          unless se.products.include?(product)
            ProductSiteElement.create!(
              product: product,
              site_element: se
            )
          end
          se.reload
          if se.products.include?(product)
            spec_sheet.destroy
          else
            puts " #*#*#*#*#*#*# The Product didn't get associated with the SiteElement. #*#*#*#*#*#*#*#*#"
          end
        end

      end
    end
  end

end


__END__

Notes about scraping the HTML resources.

  Skip the SOFTWARE ones for now
  Strip the URL down to the html file itself
  Store that for deduping.
  Get the HTML content and store it
  For now, setup nginx to proxy the image requests
  Do all the linking to products, etc.


