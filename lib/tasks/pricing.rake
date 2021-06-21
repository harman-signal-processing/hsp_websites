namespace :pricing do

  desc "2021 pricing updates"
  task :update_2021 => :environment do

    pricing_file = ENV["PRICING_UPDATE"]
    @changes = 0

    CSV.open(pricing_file, 'r:ISO-8859-1').each do |row|
      this_row_updated = false
      # First try to match by the end of the URL in the link column on the spreadsheet
      if row[6].to_s.present?
        row[6].to_s.match(/([\w\-]*)$/)
        product_id = $1
        if product = Product.where(cached_slug: product_id).first
          this_row_updated = update_product(product, row)
        end
      end

      # If the link column didn't work, try matching by the SKU
      if !this_row_updated && row[0].present?
        product_id = row[0].downcase.gsub!(/\s/, "-")
        if product = Product.where(cached_slug: product_id).first
          this_row_updated = update_product(product, row)
        end
      end

      # If the SKU column didn't work, try matching by the product name
      if !this_row_updated && row[2].present?
        product_id = row[2].downcase.gsub!(/\s/, "-")
        if product = Product.where(cached_slug: product_id).first
          this_row_updated = update_product(product, row)
        end
      end
    end

    puts "-------------------------------"
    puts "  #{ @changes } changes"

  end

  def update_product(product, row)
    puts "Updating #{ product.name }"
    if product.msrp.present?
      new_msrp_cents = (row[3].gsub(/[\$\,]/, '').to_f * 100).to_i
      puts "  MSRP: #{ product.msrp_cents } to #{ new_msrp_cents }"
      product.msrp_cents = new_msrp_cents
      @changes += 1
    end
    if product.street_price.present?
      new_map_cents = (row[4].gsub(/[\$\,]/, '').to_f * 100).to_i
      puts "  MAP: #{ product.street_price_cents } to #{ new_map_cents }"
      product.street_price_cents = new_map_cents
      @changes += 1
    end
    if product.changed?
      product.save
    end
    true
  end

end
