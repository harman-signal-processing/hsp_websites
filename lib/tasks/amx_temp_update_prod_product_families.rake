namespace :amx_temp do
  desc "Temporary rake file to easily update product family content from temporary AMX_STAGING_SERVER"
  task :update_product_families => :environment do

    t = Time.now.localtime(Time.now.in_time_zone('America/Chicago').utc_offset)
    filename = "amx_product_families_update.#{t.month}.#{t.day}.#{t.year}_#{t.strftime("%I.%M.%S_%p")}.log"
    log = ActiveSupport::Logger.new("log/#{filename}")    
    start_time = Time.now

    remote_base_url = ENV['AMX_STAGING_SERVER'] # Need to open inbound port on security group of the EC2 for the IP of this machine

    # !!!!!!!!!!!!!!!!!!
    # If true we really make updates to the database. If false we do not make updates to the database, we only do reads and output statuses.
    really_run = true
    # !!!!!!!!!!!!!!!!!!

    # !!!!!!!!!!!!!!!!!
    # If you need to pick up from where you were during the last run, set start_from_the_beginning = false.
    # You would probably only need to do this if an error occured that halted the last run of this task. 
    # This value just determines whether or not to clear the completed.txt file. If the completed.txt file 
    # contains entries these entries will be skipped on the next run.
    start_from_the_beginning = true
    # !!!!!!!!!!!!!!!!!

    write_message(log, "")
    write_message(log, "Running in #{ENV["RAILS_ENV"]}")
    write_message(log, "Making database updates: #{really_run}")
    write_message(log, "Starting from the beginning: #{start_from_the_beginning}")
    write_message(log, "") # line break

    path_to_previous_completions_file = File.join(Rails.root, "tmp", "_amx", "completed.txt")

    if start_from_the_beginning
      # clear the previous completions file
      File.truncate(path_to_previous_completions_file, 0)
    end

    # previously_completed will be empty if start_from_the_beginning=true
    previously_completed = File.readlines(path_to_previous_completions_file, chomp: true)
    # we're only updating product families that have not previously completed
    product_families_to_update = cached_slug_list - previously_completed


    product_families_to_update.each do |cached_slug|
      do_updates(log, remote_base_url, cached_slug, path_to_previous_completions_file, really_run)
    end

    end_time = Time.now
    duration = ((end_time - start_time) / 1.minute).truncate(2)

    end_time_formatted = "#{end_time.month}/#{end_time.day}/#{end_time.year} #{end_time.strftime("%I:%M:%S %p")}"
    write_message(log, "Task finished at #{end_time_formatted} and lasted #{duration} minutes.")

  end  #  task :update_product_families => :environment do

  def do_updates(log, remote_base_url, cached_slug, path_to_previous_completions_file, really_run)
    url = "/product_families/#{cached_slug}.json"

      response = HTTParty.get("#{remote_base_url}#{url}", ssl_version: :TLSv1_2)
      if response.success?
        remote = JSON.parse(response.to_json, object_class: OpenStruct)
      else
        write_message(log, "Ah, oh! Trouble connecting to #{remote_base_url}#{url}. Update not made for #{cached_slug}. Message: #{response.message}")
        return
      end

      # temp workaround for a couple cached_slugs that are different locally vs remote
      cached_slug = "amx-1g-solutions-1205" if cached_slug == "amx-1g-solutions-1203"
      cached_slug = "amx-h-264-solutions-1209" if cached_slug == "amx-h-264-solutions-1207"
      cached_slug = "amx-dvx" if cached_slug == "dvx"
      pf_to_update = ProductFamily.find_by_cached_slug(cached_slug)

    write_message(log, " ")
    write_message(log, "|||| Begin compare for #{cached_slug} ||||")
    if pf_to_update.present?
      compare(log, remote, pf_to_update, remote_base_url, really_run)
      # write to completed file so we can pickup where we left off if needed
      open(path_to_previous_completions_file, 'a') { |f| f.puts cached_slug }
    else
      write_message(log, "!!! SKIPPING !!!+++ Could not find #{cached_slug} locally +++!!!")
    end
  end  #  def do_updates(remote_base_url, cached_slug, path_to_previous_completions_file)

  def compare(log, remote, local, remote_base_url, really_run)
    # name
    is_content_different(remote.name, local.name) ? write_message(log, "***name matches", ".green") : write_message(log, "---name does NOT match", ".yellow")
    # title
    is_content_different(remote.title, local.title) ? write_message(log, "***title matches", ".green")
      : write_message(log, "---title does NOT match", ".yellow") && save_content_to_local(remote, local, "title", really_run)
    # intro
    is_content_different(remote.intro, local.intro) ? write_message(log, "***intro matches",".green") : write_message(log, "---intro does NOT match", ".yellow")
    # before_product_content
    is_content_different(remote.before_product_content, local.before_product_content) ? write_message(log, "***before_product_content matches", ".green") : write_message(log, "---before_product_content does NOT match", ".yellow")
    # accessories_content
    is_content_different(remote.accessories_content, local.accessories_content) ? write_message(log, "***accessories_content matches", ".green") : write_message(log, "---accessories_content does NOT match", ".yellow")

    # IMAGES
    # family_photo
    is_content_different(remote.family_photo, local.family_photo) ? write_message(log, "***family_photo matches", ".green") 
      : write_message(log, "---family_photo does NOT match", ".yellow") && save_image_to_local(remote_base_url, remote, local, "family_photo", really_run)
    # family_banner
    is_content_different(remote.family_banner, local.family_banner) ? write_message(log, "***family_banner matches", ".green") 
      : write_message(log, "---family_banner does NOT match", ".yellow") && save_image_to_local(remote_base_url, remote, local, "family_banner", really_run)
    # title_banner
    is_content_different(remote.title_banner, local.title_banner) ? write_message(log, "***title_banner matches", ".green") 
      : write_message(log, "---title_banner does NOT match", ".yellow") && save_image_to_local(remote_base_url, remote, local, "title_banner", really_run)
    # background_image
    is_content_different(remote.background_image, local.background_image) ? write_message(log, "***background_image matches", ".green") 
      : write_message(log, "---background_image does NOT match", ".yellow") && save_image_to_local(remote_base_url, remote, local, "background_image", really_run)

    # FEATURES
    is_content_different(remote.features.count, local.features.count) ? write_message(log, "***features.count matches", ".green") : write_message(log, "---features.count does NOT match", ".yellow")

    if remote.features.present?
      if really_run
        # removing all existing local features, will add new features from remote server below
        local.features.destroy_all
      end

      write_message(log, "-------------Begin to create features---------------")
      remote.features.each_with_index do |remote_item, pos|
        create_local_feature(log, remote_base_url, remote_item, local, really_run)
      end

    end  #  if remote.features.present?

    write_message(log, " ")

  end  #  compare(log, remote, local, remote_base_url, really_run)

  def create_local_feature(log, remote_base_url, remote_feature, local_product_family, really_run)
    write_message(log, "-------------Creating feature: #{remote_feature.name} ---------------")
    local_feature = Feature.new
    local_feature.featurable_id = local_product_family.id
    local_feature.featurable_type = local_product_family.class.name
    local_feature.position = remote_feature.position.to_i
    local_feature.layout_style = remote_feature.layout_style
    local_feature.content_position = remote_feature.content_position
    local_feature.pre_content = remote_feature.pre_content
    local_feature.content = remote_feature.content
    local_feature.use_as_banner_slide = remote_feature.use_as_banner_slide
    local_feature.show_below_products = remote_feature.show_below_products
    local_feature.show_below_videos = remote_feature.show_below_videos

    # image
    if File.basename(remote_feature.image) != "missing.png"  # only compare images if remote image not missing
      remote_path_to_image = remote_feature.image
      url_to_remote_image = "#{remote_base_url}#{remote_path_to_image}"
      image = URI.open(url_to_remote_image)
      local_feature.image = image
    end  #  if File.basename(remote_feature.image) != "missing.png"

    if really_run
      local_feature.save
    end

  end  #  def create_local_feature(log, remote_base_url, remote_feature, local_product_family, really_run)

  def is_content_different(remote_content, local_content)
    # check to see if content is an image
    # otherwise compare text content
    local_is_content_an_image =  local_content.class.to_s == "Paperclip::Attachment"
    if local_is_content_an_image
      remote_filename = File.basename(remote_content)
      local_filename = File.basename(local_content.to_s) # if is_local_content_an_image
      remote_filename == local_filename
    else
      remote_content == local_content
    end

  end  #  def is_content_different(remote, local)

  def normalize_image_name(image_name)
    image_name.gsub("_original","").gsub("_original","")
  end  #  def normalize_image_name(image_name)

  def save_image_to_local(remote_base_url, remote_item, local_item, attribute_name, really_run)
    remote_path_to_image = eval("remote_item.#{attribute_name}")
    url_to_remote_image = "#{remote_base_url}#{remote_path_to_image}"

    image = URI.open(url_to_remote_image)

    # now transfer the image to local_item
    eval("local_item.#{attribute_name}=image")

    if really_run
      local_item.save
    end

  end  #  def save_image_to_local(remote_base_url, remote_item, local_item, attribute_name)

  def save_content_to_local(remote_item, local_item, attribute_name, really_run)
    remote_content = eval("remote_item.#{attribute_name}")
    eval("local_item.#{attribute_name}=remote_content")

    if really_run
      local_item.save
    end
  end  #  def save_content_to_local(remote, local, attribute_name, really_run)

  def cached_slug_list
    ["16x16",
      "1g-solutions",
      "32x32",
      "4k30-cards-and-endpoints",
      "4k60-cards-and-endpoints",
      "64x64",
      "8x8",
      "a-v-distance-transport-solutions",
      "acendo-core",
      "acendo-vibe",
      "all-in-one-presentation-switchers",
      "amx-1g-solutions",
      "amx-1g-solutions-1203",
      "amx-accessories",
      "amx-acendo-book",
      "amx-ctc-4k60-6x1-switching-transport-kit-w-usb-c",
      "amx-ctp-4k30-4x1-switching-transport-kit",
      "amx-h-264-solutions",
      "amx-h-264-solutions-1207",
      "amx-massio-controlpads-surface-mount",
      "amx-mounting",
      "amx-mounting-519",
      "amx-mounting-531",
      "amx-n1000-series-hd-4x1",
      "amx-n2400-series-4k60-4x1",
      "amx-n3000-series-hd-9x1",
      "amx-other",
      "amx-other-346",
      "amx-power",
      "amx-power-520",
      "amx-power-547",
      "amx-precis-4k60-4x1-1",
      "amx-window-processing",
      "amx-window-processing-380",
      "apps",
      "architectural-connectivity",
      "audio-cards",
      "audio-transceivers",
      "avoip-accessories",
      "avoip-control-management",
      "blanks",
      "buttons-acc-bands",
      "cat-6",
      "central-controllers",
      "cloudworx-manager",
      "configuration-management-software",
      "control-accessories",
      "control-processing",
      "controllers-w-switching",
      "controllers-w-user-interfaces",
      "cpu-upgrade-kit",
      "ctc-4k60-6x1-switching-transport-kit-w-usb-c",
      "ctp-4k30-4x1-switching-transport-kit",
      "dce-1-in-line-controller",
      "dgx",
      "driver-design",
      "dvx",
      "dvx-4k60-up-to-8x4-2",
      "dvx-hd-up-to-10x4-2",
      "dxlink-fiber-100m",
      "dxlink-u-stp-100m",
      "dxlite-u-stp-70m",
      "edid-management-scaling-capture",
      "enclosures-w-central-controllers",
      "encoding-decoding",
      "enova-dgx",
      "fixed-switchers",
      "h-264-solutions",
      "hd-cards-and-endpoints",
      "hdmi-solutions",
      "hydraport-enclosures-grommets",
      "hydraport-modules",
      "incite",
      "incite-4k60-up-to-6x1-2",
      "io-extenders",
      "iredit",
      "keypads",
      "keypads-w-controllers",
      "massio-controlpads-surface-mount",
      "massio-surface-mount",
      "metreau-decora-style",
      "modero-g5",
      "modular-switching-systems",
      "mounting",
      "n-able-control-software",
      "n-command-controllers",
      "n-control-touch-panels-html5-javascript",
      "n1000-series-hd",
      "n1000-series-hd-4x1",
      "n2000-series-4k30",
      "n2000-series-4k30-4x1",
      "n2000-series-hd-4x1",
      "n2300-series-4k30",
      "n2400-series-4k60",
      "n2400-series-4k60-4x1",
      "n3000-series-hd",
      "n3000-series-hd-9x1",
      "netlinx-studio",
      "networked-a-v-distribution-avoip",
      "networked-video-recording-playback",
      "nmx-prs-n7142-4k60-6x2-2-svsi-card-slots",
      "pass-thru",
      "power",
      "power-modules",
      "precis-4k60-4x1-1",
      "precis-4k60-4x2-8x8-4",
      "rapid-project-maker-rpm",
      "resource-management-suite-rms",
      "retractables",
      "scheduling-collaboration",
      "scl-1-video-scaler",
      "sdx-4k30-4x1-1",
      "sdx-4k30-5x1-1",
      "switching-transport-kits-100m",
      "touch-panel-accessories",
      "touch-panel-design",
      "touch-panels",
      "tpc-android",
      "tpc-apple",
      "tpc-byod",
      "tpc-tpi-pro",
      "tpc-win8",
      "traditional-a-v-accessories",
      "traditional-a-v-distribution",
      "usb",
      "user-interfaces",
      "uvc1-4k-hdmi-to-usb-capture",
      "video",
      "video-recording-solutions",
      "video-signal-processing",
      "vpx-4k60-4x1-1",
      "vpx-4k60-7x1-1",
      "window-processing"]
  end  #  def cached_slug_list

  def write_message(log, message_to_output="", message_decoration="")
    if ENV["RAILS_ENV"] == "production"  # production doesn't have colorful puts
      puts message_to_output
    else
      puts eval(message_to_output.inspect + message_decoration)
    end
    log.info message_to_output
  end  #  def message(message)

end  #  namespace :amx_temp do