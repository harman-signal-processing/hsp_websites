namespace :utility do

  # This was written for copying the AMS brand to something else.
  # Since that brand doesn't have products, I'm opting to skip anything
  # related to products at this time.
  #
  # If there's a need to duplicate a brand that has products at some
  # point in the future, this rake task will need to be revibrandd.
  #
  # Also, this routine only deals with database entries. Items
  # inside the rails app itself will need to be manually copied.
  #
  desc "Copy brand database records to another brand"
  task brand_copy: :environment do
    from_brand = Brand.find(ENV['FROM'])
    to_brand   = Brand.find(ENV['TO'])
    raise "Usage: provide FROM, TO brand ids, which must be already in the database." unless from_brand && to_brand

    [
      Setting,
      SiteElement,
      News,
      Page,
      Software,
      ArtistBrand,
      UsRepRegion,
      BrandDistributor,
      BrandDealer,
      MarketSegment,
    ].each { |r| copy_brand_resources(r, from_brand, to_brand) }

    copy_products(from_brand, to_brand)
  end

  def copy_brand_resources(resource_class, from_brand, to_brand)
    puts "Copying #{from_brand.name} #{resource_class.to_s.pluralize}..."
    errors = []
    from_brand.send(resource_class.table_name).each do |item|
      new_item = item.dup
      new_item.brand_id = to_brand.id
      if item.respond_to?(:custom_route)
        new_item.custom_route = "#{to_brand.cached_slug}-#{item.custom_route}"
      end
      if item.respond_to?(:slide)
        new_item.slide = item.slide
      end
      if item.respond_to?(:resource)
        new_item.resource = item.resource
      end
      if item.respond_to?(:executable)
        new_item.executable = item.executable
      end
      if item.respond_to?(:news_photo)
        new_item.news_photo = item.news_photo
      end
      if item.respond_to?(:ware)
        new_item.ware = item.ware
      end
      if item.respond_to?(:cached_slug)
        new_item.cached_slug = nil
      end
      begin
        new_item.save!
        print "."
      rescue Exception => e
        print "E"
        errors << e.message
      end
    end
    print "\r"
    if errors.length > 0
      puts "  --> Errors: #{errors.to_yaml}"
    end
  end

  # TODO: write function to copy products, etc. to a new brand
  def copy_products(from_brand, to_brand)
    puts "Copying #{from_brand.name} Products...[SKIPPED: see comments in rake task]"
  end

  desc "makes some changes in the db when changing our default locale from en-US to en"
  task set_default_locale_to_en: :environment do

    # Find any JBL slideshow frames with an empty locale and set them to "en-US"
    # because there are a handful of them which are set for "en" (the new default locale)
    Setting.where(brand_id: 19, setting_type: "slideshow frame", locale: nil).update_all(locale: "en-US")
    Setting.where(brand_id: 19, setting_type: "slideshow frame", locale: "en").update_all(locale: nil)

    Website.where(default_locale: "en-US").update_all(default_locale: "en")
    Brand.where(default_locale: "en-US").update_all(default_locale: "en")
  end

  # Example: rake utility:populate_product_video_metadata[10,120]
  desc "Find and update product videos which are missing meta data"
  task :populate_product_video_metadata, [:limit, :sleep] => :environment do |task, args|
    limit = args[:limit] || 10
    sleep_time = args[:sleep] || 100
    ProductVideo.where(title: nil, duration_seconds: nil).limit(limit).order("created_at DESC").each do |pv|
      puts "Updating video: #{pv.youtube_id} (ID: #{pv.id})"
      pv.send(:populate_metadata)
      pv.save if pv.title_changed?
      puts " ... #{pv.title}" if pv.title.present?
      sleep(sleep_time.to_i)
    end
  end

  desc "Find and update product family videos which are missing meta data"
  task :populate_product_family_video_metadata, [:limit, :sleep] => :environment do |task, args|
    limit = args[:limit] || 10
    sleep_time = args[:sleep] || 100
    ProductFamilyVideo.where(title: nil, duration_seconds: nil).limit(limit).order("created_at DESC").each do |pv|
      puts "Updating video: #{pv.youtube_id} (ID: #{pv.id})"
      pv.send(:populate_metadata)
      pv.save if pv.title_changed?
      puts " ... #{pv.title}" if pv.title.present?
      sleep(sleep_time.to_i)
    end
  end
end
