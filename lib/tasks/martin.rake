namespace :martin do

  desc "Slurp up all the martin parts"
  task import_parts: :environment do

    @root_site = "http://www.martin.com"
    martin = Brand.find "martin"
    problems = []
    successes = []

    # Login to get gated content
    @agent = Mechanize.new
    p = @agent.get("#{ @root_site }/support")
    login_form = p.form_with id: "ExtUserForm"
    login_form.Username = "adamanderson"
    login_form.Password = "harman123"
    logged_in_page = login_form.click_button

    if logged_in_page.code == "200"
      puts "Logged in."
      Product.where(brand: martin).each do |product|
        puts "Getting #{ product.name }"
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
          if product_id.present?
            puts "  determined (old) product ID: #{ product_id }"
            page.css("div#sparepartListTree").css('div.bomitem').each do |bomitem|
              parse_bomitem(bomitem, product, product_id, page_id, false)
            end
            successes << product
          else
            puts "  couldn't parse the product ID from the javascript"
            problems << product
          end
        else
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
    puts "Successes: #{ successes.length }"
    puts "Problems: #{ problems.length }"
  end

  def parse_bomitem(bomitem, product, product_id, page_id, parent)
    new_part = find_or_create_part(bomitem, product, parent)

    if bomitem.search('a.showbomitems') # this has children
      # traverse the children via Ajax
      child_url = "#{ @root_site }/Martin.Ajax.aspx?cmd=sp:getbomitems&bomid=#{ new_part.part_number }&pageid=#{ page_id }&productid=#{ product_id }"
      #puts "Getting child data from: #{ child_url }"
      ajax = @agent.get(child_url)
      #puts ajax.content
      ajax.css('div.bomitem').each do |thisbomitem|
        parse_bomitem(thisbomitem, product, product_id, page_id, new_part)
      end
    end
  end

  def find_or_create_part(bomitem, product, parent)
    # find or create the item, link to the product, return part
    part_number = ""
    if bomitem.css('a.showbomitems').length > 0
      part_number = bomitem.css('a.showbomitems')[0]["data-bomid"]
      if bomitem.css('div.product').length > 0
        description = bomitem.css('div.product')[0].css('span').last.content.strip
      elsif bomitem.css('div.group1').length > 0
        description = bomitem.css('div.group1')[0].text.strip
      end
    else
      part_number = bomitem.css('div.product')[0]["data-bomid"]
      description = bomitem.css('div.product')[0].children.last.text.strip
    end

    if part_number.blank?
      puts "  skipping blank part number"
    else
      part = Part.where(part_number: part_number).first_or_initialize
      part.description ||= description
      part.parent ||= parent

      if part.photo.blank? && bomitem.css('img').length > 0
        if bomitem.css('img')[0]["src"].to_s.match(/#{part_number}\.(\w*)/)
          ext = $1
          img_url = "#{ @root_site }/files/images/products/#{ part_number }.#{ext}"
          begin
            if @agent.get(img_url).save("tmp/#{ part_number }.#{ ext }")
              img = File.open("tmp/#{ part_number }.#{ ext }")
              part.photo = img
              img.close
            end
          rescue
            puts "...couldn't get the image. Oh well."
          end
        end
      end

      part.save
      puts "Created/updated part #{ part.part_number }"
      unless product.parts.include?(part)
        product.parts << part
      end

      part
    end
  end
end
