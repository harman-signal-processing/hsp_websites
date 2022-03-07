namespace :amx_local do
    
    desc "Trying to download production assests to local for amx project"
    task :dry_run => :environment do
      
        if ENV['USE_PRODUCTION_ASSETS'] == "0"
          puts
          puts "USE_PRODUCTION_ASSETS should be set to 1 for this task to work.".red
          puts "You can find the setting in the application.yml file.".red
          puts
          exit
        end  #  if ENV['USE_PRODUCTION_ASSETS'] == "0"
        
        require 'aws-sdk-s3'
        region = 'us-east-1'
        s3_client = Aws::S3::Client.new(region: region)
        bucket_name = 'harman-hsp-web-assets' #s3_options.delete("bucket")
        
        # production    path ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
        # local         path ":rails_root/public/system/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
        
        amx_product_families = ProductFamily.where(brand: amx).order(:name)
        # download_product_family_attachments(s3_client, bucket_name, amx_product_families)
        
        amx_products = Product.where(brand: amx).order(:name)
        # download_product_page_image_attachments(s3_client, bucket_name, amx_products)
        
        amx_pages = Page.where(brand: amx).order(:title)
        # download_landing_page_feature_attachments(s3_client, bucket_name, amx_pages)
        
        amx_settings = Setting.where(brand: amx).order(:name)
        # download_settings_slide_attachments(s3_client, bucket_name, amx_settings)
        
        amx_market_segments = MarketSegment.where(brand: amx).order(:name)
        # download_market_segment_banner_attachments(s3_client, bucket_name, amx_market_segments)
        
        # resource images
        amx_site_elements = SiteElement.where(brand: amx, resource_type: "Image").order(:name)
        download_site_element_images(s3_client, bucket_name, amx_site_elements)
        
    end  #  task :dry_run => :environment do
    
    def download_product_family_attachments(s3_client, bucket_name, product_families)
        product_families.each do |pf|
            puts "product family------#{pf.name}------"
            
            if pf.family_photo.present?
              puts "family_photo -- #{pf.family_photo.path}"
              download_from_s3_to_local(s3_client, bucket_name, pf.family_photo.path)
            end
            
            # puts "background_image -- #{pf.background_image.path}"
            # download_from_s3_to_local(s3_client, bucket_name, pf.background_image.path)
            
            if pf.family_banner.present?
              puts "family_banner -- #{pf.family_banner.path}"
              download_from_s3_to_local(s3_client, bucket_name, pf.family_banner.path)
            end
            
            if pf.title_banner.present?
              puts "title_banner -- #{pf.title_banner.path}"
              download_from_s3_to_local(s3_client, bucket_name, pf.title_banner.path)
            end
            
            download_feature_attachments(s3_client, bucket_name, pf.features)
        end  #  amx_product_families.each do |apf|      
    end  #  def download_product_family_attachments(s3_client, bucket_name, product_families)
    

    def download_product_page_image_attachments(s3_client, bucket_name, products)
        products.each do |product|
          if product.background_image.present?
            puts "product-----#{product.name}-----"
            download_from_s3_to_local(s3_client, bucket_name, product.background_image.path)
          end
          
          # temporarily commented this out because we have them all now and it takes a long time to run
          download_product_attachments(s3_client, bucket_name, product)
          
          download_feature_attachments(s3_client, bucket_name, product.highlights)
          
        end  #  products.each do |product|
    end  #  def download_product_page_image_attachments(s3_client, bucket_name, products)

    def download_product_attachments(s3_client, bucket_name, product)
          # probably want to break these out to method calls so you can easily comment some out
          # because this one takes a long time
          product.product_attachments.each do |pa|
            if pa.product_attachment.present?
              
              attachment = pa.product_attachment
              styles = [:original] + attachment.styles.map{|k,v| k}
              styles.each do |style|
                attachment_path = attachment.path(style)
                puts "product_attachment -- #{attachment_path}"
                download_from_s3_to_local(s3_client, bucket_name, attachment_path)
              end  #  styles.each do |style|
              
              #binding.pry
              ## pa.product_attachment.styles[:small]
              #puts "product_attachment -- #{pa.product_attachment.path}"
              #download_from_s3_to_local(s3_client, bucket_name, pa.product_attachment.path)              
            end  #  if pa.product_attachment.present?
          end  #  p.product_attachments.each do |pa|      
    end  #  def download_product_attachments(s3_client, bucket_name, product)
    
    def download_landing_page_feature_attachments(s3_client, bucket_name, landing_pages)
        landing_pages.each do |p|
          download_feature_attachments(s3_client, bucket_name, p.features)
        end  #  landing_pages.each do |p|      
    end  #  def download_landing_page_feature_attachments(s3_client, bucket_name, landing_pages)
    
    def download_settings_slide_attachments(s3_client, bucket_name, settings)
      settings.each do |s|
        if s.slide.present?
          download_all_sizes_of_attachment(s3_client, bucket_name, s.slide, "slide show")
        end  # if s.slide.present?
      end  #  settings.each do |s|
    end  #  def download_settings_slide_attachments(s3_client, bucket_name, settings)
    
    def download_market_segment_banner_attachments(s3_client, bucket_name, market_segments)
      market_segments.each do |ms|
        if ms.banner_image.present?
          download_all_sizes_of_attachment(s3_client, bucket_name, ms.banner_image, "market segment banner")
        end  #  if ms.banner.present?
      end  #  market_segments.each do |ms|
    end  #  def download_market_segment_banner_attachments(s3_client, bucket_name, market_segments)
    
    def download_site_element_images(s3_client, bucket_name, site_elements)
      site_elements.each do |se|
        if se.resource.present?
          download_all_sizes_of_attachment(s3_client, bucket_name, se.resource, "site element")
        end  #  if se.resource.present?
      end  #  site_elements.each do |se|
    end  #  def download_site_element_images(s3_client, bucket_name, site_elements)
    
    def download_feature_attachments(s3_client, bucket_name, features)
          features.each do |f|
            if f.image.present?
              attachment = f.image
              styles = [:original] + attachment.styles.map{|k,v| k}
              styles.each do |style|
                attachment_path = attachment.path(style)
                puts "feature image -- #{attachment_path}"
                download_from_s3_to_local(s3_client, bucket_name, attachment_path)
              end  #  styles.each do |style|
            end  #  if f.image.present?
          end  #  features.each do |f|    
    end  #  def download_feature_attachments(s3_client, bucket_name, features)
    
    def download_all_sizes_of_attachment(s3_client, bucket_name, attachment, type_name_of_image)
          styles = [:original] + attachment.styles.map{|k,v| k}
          styles.each do |style|
            attachment_path = attachment.path(style)
            puts "#{type_name_of_image} image -- #{attachment_path}"
            download_from_s3_to_local(s3_client, bucket_name, attachment_path)
          end  #  styles.each do |style|
    end 
    
    def download_from_s3_to_local(s3_client, bucket_name, asset_s3_path)
        local_path_to_use = "#{Rails.root}/public/system/#{asset_s3_path}"
        FileUtils.mkdir_p(File.dirname(local_path_to_use)) #create folder if it doesn't exist"
        local_path = local_path_to_use
        # local_path = "./test.jpg"
        
        object_key = asset_s3_path
        if object_downloaded?(s3_client, bucket_name, object_key, local_path)
          puts "Object '#{object_key}' in bucket '#{bucket_name}' downloaded to '#{local_path}'.".green
        else
          puts "Object '#{object_key}' in bucket '#{bucket_name}' not downloaded.".red
        end
    end  #  def download_from_s3_to_local(asset_s3_path)

    def object_downloaded?(s3_client, bucket_name, object_key, local_path)
      s3_client.get_object(
        response_target: local_path,
        bucket: bucket_name,
        key: object_key
      )
    rescue StandardError => e
      puts "Error getting object: #{e.message}"
    end  #  def object_downloaded?(s3_client, bucket_name, object_key, local_path)

    def amx
      amx = Brand.find "amx"
    end    
end  #  namespace :amx_local do