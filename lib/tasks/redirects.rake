namespace :redirects do

  desc "Generates NGINX style redirects for each brand"
  task :generate => :environment do

    # Manual exclusion list
    exclusions = %w(eon-one eon-one-pro eon-one-compact)

    Brand.all.each do |brand|

      fn = Rails.root.join("tmp", "redirects", "#{brand.friendly_id}_redirects.config")
      tracked_ids = exclusions

      open(fn, 'w') do |f|

        # Product Families
        brand.product_families.each do |product_family|
          unless tracked_ids.include?(product_family.friendly_id)
            f.puts "location = /#{product_family.friendly_id} { return 301 /product_families/#{product_family.friendly_id}; }"
            tracked_ids << product_family.friendly_id
          end

          if product_family.old_url.present?
            old_path = product_family.old_url.match(/\.com(.*)/)[1]
            unless tracked_ids.include?(old_path)
              f.puts "location = #{old_path} { return 301 /product_families/#{product_family.friendly_id}; }"
              f.puts "location = #{old_path}/ { return 301 /product_families/#{product_family.friendly_id}; }"
              tracked_ids << old_path
            end
          end
        end

        # Products
        brand.products.each do |product|
          unless tracked_ids.include?(product.friendly_id)
            f.puts "location = /#{product.friendly_id} { return 301 /products/#{product.friendly_id}; }"
            tracked_ids << product.friendly_id
          end

          if product.friendly_id.match(/\W/)
            shortened_id = product.friendly_id.gsub(/\W/, '')
            unless tracked_ids.include?(shortened_id)
              f.puts "location = /#{shortened_id} { return 301 /products/#{product.friendly_id}; }"
              tracked_ids << shortened_id
            end
          end

          if product.old_url.present?
            old_path = product.old_url.match(/\.com(.*)/)[1]
            unless tracked_ids.include?(old_path)
              f.puts "location = #{old_path} { return 301 /products/#{product.friendly_id}; }"
              f.puts "location = #{old_path}/ { return 301 /products/#{product.friendly_id}; }"
              tracked_ids << old_path
            end
          end
        end

        # News
        brand.news.where("old_url IS NOT NULL").each do |news|
          old_path = news.old_url.match(/\.com\.{0,2}(.*)/)[1]
          unless tracked_ids.include?(old_path)
            f.puts "location = #{old_path} { return 301 /news/#{news.friendly_id}; }"
            tracked_ids << old_path
          end
        end
      end # close the file
    end # brand loop

  end
end
