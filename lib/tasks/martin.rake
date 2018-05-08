namespace :martin do

  desc "Slurp up all the martin parts"
  task import_parts: :environment do

    @root_site = "http://www.martin.com"
    martin = Brand.find "martin"
    problems = []
    successes = []

    @agent = Mechanize.new
    logged_in_page = login_to_support_page

    if logged_in_page.code == "200"
      puts "Logged in."
      Product.where(brand: martin).each do |product|
#      Product.where(cached_slug: "mac-quantum-wash").each do |product|
        puts "Getting #{ product.name }"
        begin
          page = @agent.get("#{ @root_site }/en-us/support/product-details/#{ product.friendly_id }")
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
            page.css("div#sparepartListTree").css('div.bomitem').each do |bomitem|
              parse_bomitem(bomitem, product, product_id, page_id, false)
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

    puts "Problems:"
    puts "============================="
    problems.each do |product|
      puts "    #{product.name}"
    end
    puts "============================="
    puts "Problems: #{ problems.length }"
    puts "Successes: #{ successes.length }"
  end

  def parse_bomitem(bomitem, product, product_id, page_id, parent)
    new_part = find_or_create_part(bomitem, product, parent)

    if bomitem.search('a.showbomitems') # this has children
      child_url = "#{ @root_site }/Martin.Ajax.aspx?cmd=sp:getbomitems&bomid=#{ new_part.part_number }&pageid=#{ page_id.to_s }&productid=#{ product_id.to_s }"
      ajax = @agent.get(child_url)
      ajax.css('div.bomitem').each do |thisbomitem|
        parse_bomitem(thisbomitem, product, product_id, page_id, new_part)
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
      puts "  skipping blank part number"
    else
      part = Part.where(part_number: part_number).first_or_initialize
      part.description = description unless part.description.present?
      part.parent ||= parent

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
      unless product.parts.include?(part)
        product.parts << part
      end

      part
    end
  end

  def login_to_support_page
    # Login to get gated content
    p = @agent.get("#{ @root_site }/support")
    login_form = p.form_with id: "ExtUserForm"
    login_form.Username = ENV['MARTIN_ADMIN']
    login_form.Password = ENV['MARTIN_PASSWORD']
    login_form.click_button
  end
end
