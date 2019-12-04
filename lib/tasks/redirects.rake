namespace :redirects do

  desc "Generates NGINX style redirects for each brand"
  task :generate => :environment do

    Brand.all.each do |brand|

      fn = Rails.root.join("tmp", "redirects", "#{brand.friendly_id}_redirects.config")
      family_ids = brand.product_families.pluck(:cached_slug).uniq
      product_ids = brand.products.pluck(:cached_slug).uniq - family_ids
      tracked_ids = []

      open(fn, 'w') do |f|
        family_ids.each do |product_family|
          f.puts "location = /#{product_family} { return 301 /product_families/#{product_family}; }"
          tracked_ids << product_family
        end
        product_ids.each do |product|
          next if tracked_ids.include?(product)
          f.puts "location = /#{product} { return 301 /products/#{product}; }"
          tracked_ids << product
          if product.match(/\W/)
            shortened_id = product.gsub(/\W/, '')
            next if tracked_ids.include?(shortened_id)
            f.puts "location = /#{shortened_id} { return 301 /products/#{product}; }"
            tracked_ids << shortened_id
          end
        end
      end
    end

  end
end
