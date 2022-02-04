
namespace :amx_nav do


  desc "Updates for the amx product nav"
  task :update_nav => :environment do

    create_new_product_families
    rename_product_families
    change_product_product_family
    reassign_product_families
    delete_old_product_families
    add_nav_separator_text
    create_new_nav_site_setting

  end  #  task :update_nav => :environment do

  def amx
    amx = Brand.find "amx"
  end

  def create_new_product_families

    puts "-------------CREATING #{new_product_families_to_create.count} NEW PRODUCT FAMILIES------------------"

    new_product_families_to_create.each do |pf|

      grand_parent = pf[:grand_parent_slug].present? ? ProductFamily.where(brand: amx, cached_slug: pf[:grand_parent_slug]).first : ProductFamily.where(brand: amx, name: pf[:grand_parent]).first
      parent = pf[:parent_slug].present? ? ProductFamily.where(brand: amx, cached_slug: pf[:parent_slug]).first : ProductFamily.where(brand: amx, name: pf[:parent]).first

      if parent.present? && grand_parent.present?
        begin
          new_parent = ProductFamily.where(id: parent.id, parent_id: grand_parent.id).first
        rescue => e
          puts "Issue1: #{pf}"
          puts "Error: #{e.message}".red
        end

      else
        if parent.present?
          begin
            new_parent = ProductFamily.where(id: parent.id).first
          rescue => e
            puts "Issue2: #{pf}"
            puts "Error: #{e.message}".red
          end
        end
      end

      new_family_name = pf[:name]
      parent_to_use = new_parent.present? ? new_parent : parent
      new_pf = ProductFamily.create(name: new_family_name, brand: amx, parent: parent_to_use)
      new_pf.update(position: pf[:position]) if pf[:position].present?

      if parent_to_use.present?
        puts "Created #{new_family_name} [#{new_pf.cached_slug}] (#{parent_to_use.name}) [#{parent_to_use.cached_slug}]".green
      else
        puts "Created #{new_family_name} [#{new_pf.cached_slug}] ()".green
      end

    end  #  new_product_families_to_create.each do |pf|
  end  #  def create_new_product_families

  def new_product_families_to_create
    # Note some parent product family names will change when step 2, the renaming is completed. Example: Networked AV will become Networked A/V Distribution (AVoIP)
    [
      # nil | Networked AV | Encoding & Decoding
      { name: "Encoding & Decoding", parent: "Networked AV", parent_slug: "networked-av", position: 1},
      # nil | Networked AV | Encoding & Decoding | 1G Solutions
      { name: "1G Solutions", parent: "Encoding & Decoding", parent_slug: "encoding-decoding", grand_parent: "Networked AV", grand_parent_slug: "networked-av", position: 1},
      # nil | Networked AV | Encoding & Decoding | H.264 Solutions
      { name: "H.264 Solutions", parent: "Encoding & Decoding", parent_slug: "encoding-decoding", grand_parent: "Networked AV", grand_parent_slug: "networked-av", position: 2},
      # nil | Networked AV | SVSI Windowing Processors | 1G Solutions
      { name: "1G Solutions", parent: "SVSI Windowing Processors", grand_parent: "Networked AV", position: 1},
      # nil | Networked AV | SVSI Windowing Processors | 1G Solutions | N2400 Series (4K60 4x1)
      { name: "N2400 Series (4K60 4x1)", parent: "1G Solutions", parent_slug: "amx-1g-solutions", grand_parent: "SVSI Windowing Processors", grand_parent_slug: "svsi-windowing-processors", position: 1},
      # nil | Networked AV | SVSI Windowing Processors | 1G Solutions | N2000 Series (HD 4x1)
      { name: "N2000 Series (HD 4x1)", parent: "1G Solutions", parent_slug: "amx-1g-solutions", grand_parent: "SVSI Windowing Processors", grand_parent_slug: "svsi-windowing-processors", position: 2},
      # nil | Networked AV | SVSI Windowing Processors | 1G Solutions | N1000 Series (HD 4x1)
      { name: "N1000 Series (HD 4x1)", parent: "1G Solutions", parent_slug: "amx-1g-solutions", grand_parent: "SVSI Windowing Processors", grand_parent_slug: "svsi-windowing-processors", position: 3},
      # nil | Networked AV | SVSI Windowing Processors | H.264 Solutions
      { name: "H.264 Solutions", parent: "SVSI Windowing Processors", parent_slug: "svsi-windowing-processors", grand_parent: "Networked AV", grand_parent_slug: "networked-av", position: 2},
      # nil | Networked AV | SVSI Windowing Processors | H.264 Solutions | N3000 Series (HD 9x1)
      { name: "N3000 Series (HD 9x1)", parent: "H.264 Solutions", parent_slug: "amx-h-264-solutions", grand_parent: "SVSI Windowing Processors", grand_parent_slug: "svsi-windowing-processors", position: 1},
      # nil | Networked AV | AVoIP Control & Management
      { name: "AVoIP Control & Management", parent: "Networked AV", parent_slug: "networked-av", position: 5},
      # nil | Networked AV | SVSI Accessories | Mounting               ****SVSI Accessories will be renamed to AVoIP Accessories in next step
      { name: "Mounting", parent: "SVSI Accessories", position: 1},
      # nil | Networked AV | SVSI Accessories | Power               ****SVSI Accessories will be renamed to AVoIP Accessories in next step
      { name: "Power", parent: "SVSI Accessories", position: 2},
      # nil | Traditional A/V Distribution
      { name: "Traditional A/V Distribution", parent: nil, position: 2},
      # nil | Traditional A/V Distribution | Presentation Switchers | DVX 4K60 (Up to 8x4 +2)            ****Presentation Switchers will be renamed to All-In-One Presentation Switchers in next step
      { name: "DVX 4K60 (Up to 8x4 +2)", parent: "Presentation Switchers", grand_parent: "Traditional A/V Distribution", position: 1},
      # nil | Traditional A/V Distribution | Presentation Switchers | DVX HD (Up to 10x4 +2)            ****Presentation Switchers will be renamed to All-In-One Presentation Switchers in next step
      { name: "DVX HD (Up to 10x4 +2)", parent: "Presentation Switchers", grand_parent: "Traditional A/V Distribution", position: 2},
      # nil | Traditional A/V Distribution | Fixed Switchers
      { name: "Fixed Switchers", parent: "Traditional A/V Distribution", position: 2},
      # nil | Traditional A/V Distribution | Fixed Switchers | CTC (4K60 6x1) Switching & Transport Kit w/ USB-C
      { name: "CTC (4K60 6x1) Switching & Transport Kit w/ USB-C", parent: "Fixed Switchers", grand_parent: "Traditional A/V Distribution", position: 2},
      # nil | Traditional A/V Distribution | Fixed Switchers | CTC (4K60 6x1) Switching & Transport Kit w/ USB-C
      { name: "CTP (4K30 4x1) Switching & Transport Kit", parent: "Fixed Switchers", grand_parent: "Traditional A/V Distribution", position: 3},
      # nil | Traditional A/V Distribution | Fixed Switchers | VPX (4K60 4x1 +1)
      { name: "VPX (4K60 4x1 +1)", parent: "Fixed Switchers", grand_parent: "Traditional A/V Distribution", position: 4},
      # nil | Traditional A/V Distribution | Fixed Switchers | VPX (4K60 4x1 +1)
      { name: "VPX (4K60 7x1 +1)", parent: "Fixed Switchers", grand_parent: "Traditional A/V Distribution", position: 5},
      # nil | Traditional A/V Distribution | Fixed Switchers | VPX (4K60 4x1 +1)
      { name: "SDX (4K30 4x1 +1)", parent: "Fixed Switchers", grand_parent: "Traditional A/V Distribution", position: 6},
      # nil | Traditional A/V Distribution | Fixed Switchers | VPX (4K60 4x1 +1)
      { name: "SDX (4K30 5x1 +1)", parent: "Fixed Switchers", grand_parent: "Traditional A/V Distribution", position: 7},
      # nil | Traditional A/V Distribution | Modular Switching Systems
      { name: "Modular Switching Systems", parent: "Traditional A/V Distribution", position: 3},
      # nil | Traditional A/V Distribution | Modular Switching Systems | Enclosures (w/ Central Controllers) | 8x8
      { name: "8x8", parent: "Enclosures (w/ Central Controllers)", grand_parent: "Modular Switching Systems", position: 1},
      # nil | Traditional A/V Distribution | Modular Switching Systems | Enclosures (w/ Central Controllers) | 16x16
      { name: "16x16", parent: "Enclosures (w/ Central Controllers)", grand_parent: "Modular Switching Systems", position: 2},
      # nil | Traditional A/V Distribution | Modular Switching Systems | Enclosures (w/ Central Controllers) | 32x32
      { name: "32x32", parent: "Enclosures (w/ Central Controllers)", grand_parent: "Modular Switching Systems", position: 3},
      # nil | Traditional A/V Distribution | Modular Switching Systems | Enclosures (w/ Central Controllers) | 64x64
      { name: "64x64", parent: "Enclosures (w/ Central Controllers)", grand_parent: "Modular Switching Systems", position: 4},
      # nil | Traditional A/V Distribution | Modular Switching Systems | Enclosures (w/ Central Controllers) | 64x64
      { name: "CPU Upgrade Kit", parent: "Enclosures (w/ Central Controllers)", grand_parent: "Modular Switching Systems", position: 5},
      # nil | Traditional A/V Distribution | Modular Switching Systems | 4K60 Cards and Endpoints
      { name: "4K60 Cards and Endpoints", parent: "Modular Switching Systems", grand_parent: "Traditional A/V Distribution", position: 3},
      # nil | Traditional A/V Distribution | Modular Switching Systems | 4K30 Cards and Endpoints
      { name: "4K30 Cards and Endpoints", parent: "Modular Switching Systems", grand_parent: "Traditional A/V Distribution", position: 4},
      # nil | Traditional A/V Distribution | Modular Switching Systems | HD Cards and Endpoints
      { name: "HD Cards and Endpoints", parent: "Modular Switching Systems", grand_parent: "Traditional A/V Distribution", position: 5},
      # nil | Traditional A/V Distribution | Modular Switching Systems | Audio Cards
      { name: "Audio Cards", parent: "Modular Switching Systems", grand_parent: "Traditional A/V Distribution", position: 6},
      # nil | Traditional A/V Distribution | A/V Distance Transport Solutions
      { name: "A/V Distance Transport Solutions", parent: "Traditional A/V Distribution", position: 4},
      # nil | Traditional A/V Distribution | A/V Distance Transport Solutions | DXLink Fiber (>100m)
      { name: "DXLink Fiber (>100m)", parent: "A/V Distance Transport Solutions", grand_parent: "Traditional A/V Distribution", position: 1},
      # nil | Traditional A/V Distribution | A/V Distance Transport Solutions | DXLink U/STP (<100m)
      { name: "DXLink U/STP (<100m)", parent: "A/V Distance Transport Solutions", grand_parent: "Traditional A/V Distribution", position: 2},
      # nil | Traditional A/V Distribution | A/V Distance Transport Solutions | DXLite U/STP (<70m)
      { name: "DXLite U/STP (<70m)", parent: "A/V Distance Transport Solutions", grand_parent: "Traditional A/V Distribution", position: 3},
      # nil | Traditional A/V Distribution | Window Processing
      { name: "Window Processing", parent: "Traditional A/V Distribution", position: 5},
      # nil | Traditional A/V Distribution | Window Processing | Precis (4K60 4x1 + 1)
      { name: "Precis (4K60 4x1 + 1)", parent: "Window Processing", grand_parent: "Traditional A/V Distribution", position: 1},
      # nil | Traditional A/V Distribution | Traditional A/V Accessories
      { name: "Traditional A/V Accessories", parent: "Traditional A/V Distribution", position: 6},
      # nil | Traditional A/V Distribution | Traditional A/V Accessories | Mounting
      { name: "Mounting", parent: "Traditional A/V Accessories", grand_parent: "Traditional A/V Distribution", position: 1},
      # nil | Traditional A/V Distribution | Traditional A/V Accessories | Power
      { name: "Power", parent: "Traditional A/V Accessories", grand_parent: "Traditional A/V Distribution", position: 2},
      # nil | Video Signal Processing
      { name: "Video Signal Processing", parent: nil, position: 3},
      # nil | Video Signal Processing | EDID Management, Scaling, & Capture
      { name: "EDID Management, Scaling, & Capture", parent: "Video Signal Processing", position: 1},
      # nil | Video Signal Processing | EDID Management, Scaling, & Capture | DCE-1 In-Line Controller
      { name: "DCE-1 In-Line Controller", parent: "EDID Management, Scaling, & Capture", grand_parent: "Video Signal Processing", position: 1},
      # nil | Video Signal Processing | EDID Management, Scaling, & Capture | SCL-1 Video Scaler
      { name: "SCL-1 Video Scaler", parent: "EDID Management, Scaling, & Capture", grand_parent: "Video Signal Processing", position: 2},
      # nil | Video Signal Processing | EDID Management, Scaling, & Capture | UVC1-4K HDMI to USB Capture
      { name: "UVC1-4K HDMI to USB Capture", parent: "EDID Management, Scaling, & Capture", grand_parent: "Video Signal Processing", position: 3},
      # nil | Video Signal Processing | Window Processing
      { name: "Window Processing", parent: "Video Signal Processing", parent_slug: "video-signal-processing", position: 2},
      # nil | Video Signal Processing | Window Processing | HDMI Solutions
      { name: "HDMI Solutions", parent: "Window Processing", parent_slug: "amx-window-processing", grand_parent: "Video Signal Processing", grand_parent_slug: "video-signal-processing", position: 1},
      # nil | Video Signal Processing | Window Processing | HDMI Solutions | Precis (4K60 4x1 + 1)
      { name: "Precis (4K60 4x1 + 1)", parent: "HDMI Solutions", parent_slug: "hdmi-solutions", grand_parent: "Window Processing", grand_parent_slug: "video-signal-processing", position: 1},
      # nil | Video Signal Processing | Window Processing | 1G Solutions
      { name: "1G Solutions", parent: "Window Processing", parent_slug: "amx-window-processing", grand_parent: "Video Signal Processing", grand_parent_slug: "video-signal-processing", position: 2},
      # nil | Video Signal Processing | Window Processing | 1G Solutions | N2400 Series (4K60 4x1)
      { name: "N2400 Series (4K60 4x1)", parent: "1G Solutions", parent_slug: "amx-1g-solutions-1203", grand_parent: "Window Processing", grand_parent_slug: "amx-window-processing", position: 1},
      # nil | Video Signal Processing | Window Processing | 1G Solutions | N2000 Series (4K30 4x1)
      { name: "N2000 Series (4K30 4x1)", parent: "1G Solutions", parent_slug: "amx-1g-solutions-1203", grand_parent: "Window Processing", grand_parent_slug: "amx-window-processing", position: 2},
      # nil | Video Signal Processing | Window Processing | 1G Solutions | N1000 Series (HD 4x1)
      { name: "N1000 Series (HD 4x1)", parent: "1G Solutions", parent_slug: "amx-1g-solutions-1203", grand_parent: "Window Processing", grand_parent_slug: "amx-window-processing", position: 3},
      # nil | Video Signal Processing | Window Processing | H.264 Solutions
      { name: "H.264 Solutions", parent: "Window Processing", parent_slug: "amx-window-processing", grand_parent: "Video Signal Processing", grand_parent_slug: "video-signal-processing", position: 3},
      # nil | Video Signal Processing | Window Processing | H.264 Solutions | N3000 Series (HD 9x1)
      { name: "N3000 Series (HD 9x1)", parent: "H.264 Solutions", parent_slug: "amx-h-264-solutions-1207", grand_parent: "Window Processing", grand_parent_slug: "amx-window-processing", position: 1},
      # nil | Video Signal Processing | Networked Video Recording & Playback
      { name: "Networked Video Recording & Playback", parent: "Video Signal Processing", parent_slug: "video-signal-processing", grand_parent: nil, grand_parent_slug: nil, position: 3},
      # nil | Architectural Connectivity | Accessories
      { name: "Accessories", parent: "Architectural Connectivity", parent_slug: "architectural-connectivity", grand_parent: nil, grand_parent_slug: nil, position: 3},
      # nil | Scheduling & Collaboration | CTC (4K60 6x1) Switching & Transport Kit w/ USB-C
      { name: "CTC (4K60 6x1) Switching & Transport Kit w/ USB-C", parent: "Scheduling & Collaboration", parent_slug: "scheduling-collaboration", grand_parent: nil, grand_parent_slug: nil, position: 4},
      # nil | Scheduling & Collaboration | CTP (4K30 4x1) Switching & Transport Kit
      { name: "CTP (4K30 4x1) Switching & Transport Kit", parent: "Scheduling & Collaboration", parent_slug: "scheduling-collaboration", grand_parent: nil, grand_parent_slug: nil, position: 5},
      # nil | User Interfaces | Keypads
      { name: "Keypads", parent: "User Interfaces", parent_slug: "user-interfaces", grand_parent: nil, grand_parent_slug: nil, position: 2},
      # nil | User Interfaces | Keypads | Massio (Surface Mount)
      { name: "Massio (Surface Mount)", parent: "Keypads", parent_slug: "keypads", grand_parent: "User Interfaces", grand_parent_slug: "user-interfaces", position: 2},
      # nil | User Interfaces | Keypads w/ Controllers
      { name: "Keypads w/ Controllers", parent: "User Interfaces", parent_slug: "user-interfaces", grand_parent: nil, grand_parent_slug: nil, position: 3},
      # nil | User Interfaces | Keypads w/ Controllers | Massio ControlPads (Surface Mount)
      { name: "Massio ControlPads (Surface Mount)", parent: "Keypads w/ Controllers", parent_slug: "keypads-w-controllers", grand_parent: "User Interfaces", grand_parent_slug: "user-interfaces", position: 1},
      # nil | User Interfaces | Apps | TPC-APPLE
      { name: "TPC-APPLE", parent: "Apps", parent_slug: "apps", grand_parent: "User Interfaces", grand_parent_slug: "user-interfaces", position: 2},
      # nil | User Interfaces | Apps | TPC-ANDROID
      { name: "TPC-ANDROID", parent: "Apps", parent_slug: "apps", grand_parent: "User Interfaces", grand_parent_slug: "user-interfaces", position: 3},
      # nil | User Interfaces | Apps | TPC-WIN8
      { name: "TPC-WIN8", parent: "Apps", parent_slug: "apps", grand_parent: "User Interfaces", grand_parent_slug: "user-interfaces", position: 4},
      # nil | User Interfaces | Apps | TPC-BYOD
      { name: "TPC-BYOD", parent: "Apps", parent_slug: "apps", grand_parent: "User Interfaces", grand_parent_slug: "user-interfaces", position: 5},
      # nil | Control Processing | Control Accessories | Other
      { name: "Other", parent: "Control Accessories", parent_slug: "control-accessories", grand_parent: "Control Processing", grand_parent_slug: "control-processing", position: 3},
      # nil | Control Processing | Controllers w/ User Interfaces
      { name: "Controllers w/ User Interfaces", parent: "Control Processing", parent_slug: "control-processing", grand_parent: nil, grand_parent_slug: nil, position: 4},
      # nil | Control Processing | Controllers w/ User Interfaces | Massio ControlPads (Surface Mount)
      { name: "Massio ControlPads (Surface Mount)", parent: "Controllers w/ User Interfaces", parent_slug: "control-w-user-interfaces", grand_parent: "Control Processing", grand_parent_slug: "control-processing", position: 1},
      # nil | Control Processing | Controllers w/ Switching
      { name: "Controllers w/ Switching", parent: "Control Processing", parent_slug: "control-processing", grand_parent: nil, grand_parent_slug: nil, position: 5},
      # Control Processing | Controllers w/ Switching | DGX
      { name: "DGX", parent: "Controllers w/ Switching", parent_slug: "controllers-w-switching", grand_parent: "Control Processing", grand_parent_slug: "control-processing", position: 1},
      # Control Processing | Controllers w/ Switching | DVX
      { name: "DVX", parent: "Controllers w/ Switching", parent_slug: "controllers-w-switching", grand_parent: "Control Processing", grand_parent_slug: "control-processing", position: 2},
      # nil | Control Processing | Controllers w/ Switching | Incite
      { name: "Incite", parent: "Controllers w/ Switching", parent_slug: "controllers-w-switching", grand_parent: "Control Processing", grand_parent_slug: "control-processing", position: 5},
      # nil | Configuration & Management Software | Rapid Project Maker (RPM)
      { name: "Rapid Project Maker (RPM)", parent: "Configuration & Management Software", parent_slug: "configuration-management-software", grand_parent: nil, grand_parent_slug: nil, position: 1},
      # nil | Configuration & Management Software | NetLinx Studio
      { name: "NetLinx Studio", parent: "Configuration & Management Software", parent_slug: "configuration-management-software", grand_parent: nil, grand_parent_slug: nil, position: 2},
      # nil | Configuration & Management Software | Driver Design
      { name: "Driver Design", parent: "Configuration & Management Software", parent_slug: "configuration-management-software", grand_parent: nil, grand_parent_slug: nil, position: 3},
      # nil | Configuration & Management Software | IREdit
      { name: "IREdit", parent: "Configuration & Management Software", parent_slug: "configuration-management-software", grand_parent: nil, grand_parent_slug: nil, position: 4},
      # nil | Configuration & Management Software | Touch Panel Design
      { name: "Touch Panel Design", parent: "Configuration & Management Software", parent_slug: "configuration-management-software", grand_parent: nil, grand_parent_slug: nil, position: 5}
    ]
  end  #  def new_product_families_to_create

  def rename_product_families
    puts "-------------RENAMING #{product_families_to_rename.count} EXISTING PRODUCT FAMILIES------------------"

    product_families_to_rename.each do |pf|
      grand_parent = pf[:grand_parent_slug].present? ? ProductFamily.where(cached_slug: pf[:grand_parent_slug]) : ProductFamily.where(name: pf[:grand_parent])
      parent = pf[:parent_slug].present? ? ProductFamily.where(cached_slug: pf[:parent_slug]) : ProductFamily.where(name: pf[:parent])

      if grand_parent.present?
        new_parent = ProductFamily.where(id: parent.ids, parent_id: grand_parent.ids).first
      else
        new_parent = ProductFamily.where(id: parent.ids).first
      end
      product_family_to_rename = pf[:old_slug].present? ? ProductFamily.where(name: pf[:old_slug], brand_id: amx.id).first : ProductFamily.where(name: pf[:old], brand_id: amx.id).first

      if product_family_to_rename.present?

        old_pf_name = product_family_to_rename.name
        old_pf_slug = product_family_to_rename.cached_slug
        product_family_to_rename.name = pf[:new]
        product_family_to_rename.position = pf[:position] if pf[:position].present?

          if new_parent.present?
            begin
              product_family_to_rename.parent = new_parent
            rescue => e
              puts "Error changing pf parent: #{e.message}".red
            end
          end

        product_family_to_rename.save
        puts "#{old_pf_name} [#{old_pf_slug}] renamed --> #{pf[:new]} [#{product_family_to_rename.cached_slug}]".green

      end  #  if product_family_to_rename.present?

    end  #  product_families_to_rename.each do |pf|

  end  #  def rename_product_families

  def product_families_to_rename
    [
      { old: "Networked AV", new: "Networked A/V Distribution (AVoIP)", parent: nil, position: 1},
      # Networked A/V Distribution (AVoIP) | Encoding & Decoding | 1G Solutions
      { old: "SVSI N2400 4K Series", new: "N2400 Series (4K60)", parent: "1G Solutions", grand_parent: "Encoding & Decoding", position: 1},
      { old: "SVSI N2300 4K Series", new: "N2300 Series (4K30)", parent: "1G Solutions", grand_parent: "Encoding & Decoding", position: 2},
      { old: "SVSI N2000 Series JPEG2000 /LAN", new: "N2000 Series (4K30)", parent: "1G Solutions", grand_parent: "Encoding & Decoding", position: 3},
      { old: "SVSI N1000 Series Minimal Compression / In-Room", new: "N1000 Series (HD)", parent: "1G Solutions", grand_parent: "Encoding & Decoding", position: 4},
      # Networked A/V Distribution (AVoIP) | Encoding & Decoding | H.264 Solutions
      { old: "SVSI N3000 Series H.264 / WAN", new: "N3000 Series (HD)", parent: "H.264 Solutions", grand_parent: "Encoding & Decoding", position: 1},
      # Networked A/V Distribution (AVoIP) | Window Processing
      { old: "SVSI Windowing Processors", new: "Window Processing", parent: "Networked A/V Distribution (AVoIP)", position: 2},
      { old: "SVSI Network Video Recorder", new: "Video Recording Solutions", parent: "Networked A/V Distribution (AVoIP)", position: 3},
      { old: "SVSI Audio Transceivers", new: "Audio Transceivers", parent: "Networked A/V Distribution (AVoIP)", position: 4},
      # Networked A/V Distribution (AVoIP) | AVoIP Control & Management | N-Command Controllers
      { old: "SVSI Control Appliances", new: "N-Command Controllers", parent: "AVoIP Control & Management", grand_parent: "Networked A/V Distribution (AVoIP)", position: 1},
      { old: "SVSI N-Control Touch Panels", new: "N-Control Touch Panels (HTML5/JavaScript)", parent: "AVoIP Control & Management", grand_parent: "Networked A/V Distribution (AVoIP)", position: 2},
      { old: "SVSI Tools", new: "N-Able Control Software", parent: "AVoIP Control & Management", grand_parent: "Networked A/V Distribution (AVoIP)", position: 3},
      # Networked A/V Distribution (AVoIP) | AVoIP Accessories
      { old: "SVSI Accessories", new: "AVoIP Accessories", parent: "Networked A/V Distribution (AVoIP)", position: 6},
      # Traditional A/V Distribution | All-In-One Presentation Switchers
      { old: "Presentation Switchers", new: "All-In-One Presentation Switchers", parent: "Traditional A/V Distribution", position: 1},
      # Traditional A/V Distribution | All-In-One Presentation Switchers | Incite 4K60 (Up to 6x1 +2)
      { old: "Incite Digital Presentation Systems", new: "Incite 4K60 (Up to 6x1 +2)", parent: "All-In-One Presentation Switchers", position: 3},
      { old: "SVSI Networked AV Presentation Switchers", new: "NMX-PRS-N7142 (4K60 6x2 + 2 SVSI Card Slots)", parent: "All-In-One Presentation Switchers", position: 4},
      { old: "Precis Series Matrix Switchers & Windowing Processors", new: "Precis (4K60 4x2 - 8x8 +4)", parent: "All-In-One Presentation Switchers", position: 1},
      { old: "Digital Media Switchers", new: "Enova DGX", parent: "Modular Switching Systems", grand_parent: "Traditional A/V Distribution", position: 1},
      { old: "Enova DGX Enclosures", new: "Enclosures (w/ Central Controllers)", parent: "Modular Switching Systems", grand_parent: "Traditional A/V Distribution", position: 2},
      # Traditional A/V Distribution | A/V Distance Transport Solutions | Switching & Transport Kits (<100m)
      { old: "CT Series", new: "Switching & Transport Kits (<100m)", parent: "A/V Distance Transport Solutions", grand_parent: "Traditional A/V Distribution", position: 4},
      # Architectural Connectivity | HydraPort Enclosures & Grommets
      { old: "HydraPort Connection Ports", new: "HydraPort Enclosures & Grommets", parent: "Architectural Connectivity", parent_slug: "architectural-connectivity", grand_parent: nil, position: 1},
      # # Architectural Connectivity | HydraPort Modules
      { old: "HydraPort Modules for HPX-600/900/1200 and HydraPort Touch", new: "HydraPort Modules", parent: "Architectural Connectivity", parent_slug: "architectural-connectivity", grand_parent: nil, position: 2},
      # Scheduling & Collaboration
      { old: "Workspace & Collaboration", new: "Scheduling & Collaboration", parent: nil, parent_slug: nil, grand_parent: nil, position: 6},
      # User Interfaces | Touch Panels | Modero G5
      { old: "Modero G5 Touch Panels", new: "Modero G5", parent: "Touch Panels", parent_slug: "touch-panels", grand_parent: "User Interfaces", position: 1},
      # User Interfaces | Touch Panels | Touch Panel Accessories
      { old: "UI Accessories", new: "Touch Panel Accessories", parent: "Touch Panels", parent_slug: "touch-panels", grand_parent: "User Interfaces", position: 1},
      # User Interfaces | Touch Panels | Touch Panel Accessories | Mounting
      { old: "Modero & Acendo Book Mounting Options", new: "Mounting", parent: "Touch Panel Accessories", parent_slug: "touch-panel-accessories", grand_parent: "Touch Panels", position: 1},
      # User Interfaces | Touch Panels | Touch Panel Accessories | Power
      { old: "Modero Power Supplies", new: "Power", parent: "Touch Panel Accessories", parent_slug: "touch-panel-accessories", grand_parent: "Touch Panels", position: 2},
      # User Interfaces | Touch Panels | Touch Panel Accessories | Other
      { old: "Modero Touch Panel Accessories", new: "Other", parent: "Touch Panel Accessories", parent_slug: "touch-panel-accessories", grand_parent: "Touch Panels", position: 3},
      # User Interfaces | Keypads | Metreau (Decora Style)
      { old: "Metreau Keypads® with Ethernet", new: "Metreau (Decora Style)", parent: "Keypads", grand_parent: "User Interfaces", position: 1},
      # User Interfaces | Apps
      { old: "Touch Panel Control", new: "Apps", parent: "User Interfaces", position: 4},
      # User Interfaces | Apps |TPC-TPI-PRO
      { old: "Presentation Apps", new: "TPC-TPI-PRO", parent: "Apps", grand_parent: "User Interfaces", position: 1},
      # Control Processing
      { old: "Device Control", new: "Control Processing", parent: nil, position: 8},
      # Control Processing | IO Exteners
      { old: "Control Boxes", new: "IO Extenders", parent: "Control Processing", position: 2},
      # Control Processing | Control Accessories
      { old: "Control System Accessories", new: "Control Accessories", parent: "Control Processing", position: 3},
      # Control Processing | Control Accessories | Mounting
      { old: "System Installation", new: "Mounting", parent: "Control Accessories", grand_parent: "Control Processing", position: 1},
      # Control Processing | Control Accessories | Power
      { old: "Power Supplies", new: "Power", parent: "Control Accessories", grand_parent: "Control Processing", position: 2},
      # Control Processing | Controllers w/ Switching | DGX
      { old: "Digital Media Switchers", new: "DGX", parent: "Controllers w/ Switching", grand_parent: "Control Processing", position: 1},
      # Control Processing | Controllers w/ Switching | DVX
      { old: "Enova DVX Presentation Switchers", new: "DVX", parent: "Controllers w/ Switching", grand_parent: "Control Processing", position: 2},
      # Configuration & Management Software
      { old: "AV Management Software", new: "Configuration & Management Software", parent: nil, grand_parent: nil, position: 9},
      # Configuration & Management Software | Resource Management Suite (RMS)
      { old: "Resource Management Suite Enterprise", new: "Resource Management Suite (RMS)", parent: "Configuration & Management Software", grand_parent: nil, position: 7}
    ]
  end  #  def product_families_to_rename

  def change_product_product_family
    puts "-------------CHANGING PRODUCT FAMILIES FOR #{product_product_families_to_change.count} EXISTING PRODUCTS------------------"

    product_product_families_to_change.each do |p|

      product = p[:product_slug].present? ? Product.where(brand: amx, cached_slug: p[:product_slug]).first : Product.where(brand: amx, name: p[:product_name]).first
      product_family_to_remove = p[:remove_from_product_family_slug].present? ? ProductFamily.where(brand: amx, cached_slug: p[:remove_from_product_family_slug]).first : ProductFamily.where(brand: amx, name: p[:remove_from_product_family]).first
      new_product_family = p[:new_product_family_slug].present? ? ProductFamily.where(brand: amx, cached_slug: p[:new_product_family_slug]).first : ProductFamily.where(brand: amx, name: p[:new_product_family]).first
      grand_parent_product_family = p[:grand_parent_product_family_slug].present? ? ProductFamily.where(brand: amx, cached_slug: p[:grand_parent_product_family_slug]).first : ProductFamily.where(brand: amx, name: p[:grand_parent_product_family]).first


      if product.present? && product_family_to_remove.present?
        puts "Removing #{product.name} from --xxx #{product_family_to_remove.name}".yellow
        product.product_family_products.where(product_family: product.product_families.find_by_name(product_family_to_remove.name)).delete_all
      end

      # if grand_parent_product_family.present?
      #   begin
      #     new_family_name = ProductFamily.where(id: new_product_family.id, parent_id: grand_parent_product_family.id).first
      #   rescue => e
      #     binding.pry
      #     puts "Error finding grand parent family #{grand_parent_product_family.name}: #{e.message}".red
      #   end
      # end

      if product.present? && new_product_family.present?

        if grand_parent_product_family.present?
          begin
            puts "Adding #{product.name} to ---> #{new_product_family.name} [#{new_product_family.cached_slug}] (#{grand_parent_product_family.name} [#{grand_parent_product_family.cached_slug}])".green
          rescue => e
            puts "Error adding #{product.name} to family with family parent: #{e.message}".red
          end
        else
          begin
            puts "Adding #{product.name} to ---> #{new_product_family.name} [#{new_product_family.cached_slug}]".green
          rescue => e
            puts "Error adding #{product.name} to family: #{e.message}".red
          end
        end

        begin
          ProductFamilyProduct.create(product: product, product_family: new_product_family)
        rescue => e
          puts "Error creating: #{e.message}".red
        end
      end

    end  #  product_product_families_to_change.each do |p|

  end  #  def change_product_product_family

  def product_product_families_to_change
    # change product family for these products
    [
      { product_name: "NMX-WP-N2410 Windowing Processor",   product_slug: "nmx-wp-n2410-windowing-processor", remove_from_product_family: "Window Processing",                  remove_from_product_family_slug: "amx-window-processing-380",         new_product_family: "N2400 Series (4K60 4x1)",                            new_product_family_slug: "n2400-series-4k60-4x1", grand_parent_product_family: "1G Solutions", grand_parent_product_family_slug: "amx-1g-solutions"},
      { product_name: "NMX-WP-N2510 Windowing Processor",   product_slug: "nmx-wp-n2510-windowing-processor", remove_from_product_family: "Window Processing",                  remove_from_product_family_slug: "amx-window-processing-380",         new_product_family: "N2000 Series (HD 4x1)",                              new_product_family_slug: "n2000-series-hd-4x1", grand_parent_product_family: "1G Solutions", grand_parent_product_family_slug: "amx-1g-solutions"},
      { product_name: "NMX-WP-N1512 Windowing Processor",   product_slug: "nmx-wp-n1512-windowing-processor", remove_from_product_family: "Window Processing",                  remove_from_product_family_slug: "amx-window-processing-380",         new_product_family: "N1000 Series (HD 4x1)",                              new_product_family_slug: "n1000-series-hd-4x1", grand_parent_product_family: "1G Solutions", grand_parent_product_family_slug: "amx-1g-solutions"},
      { product_name: "NMX-WP-N3510 Windowing Processor",   product_slug: "nmx-wp-n3510-windowing-processor", remove_from_product_family: "Window Processing",                  remove_from_product_family_slug: "amx-window-processing-380",         new_product_family: "N3000 Series (HD 9x1)",                              new_product_family_slug: "n3000-series-hd-9x1"},
      { product_name: "NMX-ACC-N9101",                      product_slug: "nmx-acc-n9101",                    remove_from_product_family: "AVoIP Accessories",                  remove_from_product_family_slug: "avoip-accessories",                 new_product_family: "Mounting",                                           new_product_family_slug: "mounting",                  grand_parent_product_family: "AVoIP Accessories",                   grand_parent_product_family_slug: "avoip-accessories"},
      { product_name: "NMX-ACC-N9102",                      product_slug: "nmx-acc-n9102",                    remove_from_product_family: "AVoIP Accessories",                  remove_from_product_family_slug: "avoip-accessories",                 new_product_family: "Mounting",                                           new_product_family_slug: "mounting",                  grand_parent_product_family: "AVoIP Accessories",                   grand_parent_product_family_slug: "avoip-accessories"},
      { product_name: "NMX-ACC-N9206",                      product_slug: "nmx-acc-n9206",                    remove_from_product_family: "AVoIP Accessories",                  remove_from_product_family_slug: "avoip-accessories",                 new_product_family: "Mounting",                                           new_product_family_slug: "mounting",                  grand_parent_product_family: "AVoIP Accessories",                   grand_parent_product_family_slug: "avoip-accessories"},
      { product_name: "NMX-VRK",                            product_slug: "nmx-vrk",                          remove_from_product_family: "Vision² Accessories",                remove_from_product_family_slug: "vision-accessories",                new_product_family: "Mounting",                                           new_product_family_slug: "mounting",                  grand_parent_product_family: "AVoIP Accessories",                   grand_parent_product_family_slug: "avoip-accessories"},
      { product_name: "NMX-ACC-N9312",                      product_slug: "nmx-acc-n9312",                    remove_from_product_family: "AVoIP Accessories",                  remove_from_product_family_slug: "avoip-accessories",                 new_product_family: "Power",                                              new_product_family_slug: "power",                     grand_parent_product_family: "AVoIP Accessories",                   grand_parent_product_family_slug: "avoip-accessories"},
      { product_name: "NMX-ACC-N9382",                      product_slug: "nmx-acc-n9382",                    remove_from_product_family: "AVoIP Accessories",                  remove_from_product_family_slug: "avoip-accessories",                 new_product_family: "Power",                                              new_product_family_slug: "power",                     grand_parent_product_family: "AVoIP Accessories",                   grand_parent_product_family_slug: "avoip-accessories"},
      { product_name: "DVX-2265-4K",                        product_slug: "dvx-2265-4k",                      remove_from_product_family: "All-In-One Presentation Switchers",  remove_from_product_family_slug: "all-in-one-presentation-switchers", new_product_family: "DVX 4K60 (Up to 8x4 +2)",                            new_product_family_slug: "dvx-4k60-up-to-8x4-2"},
      { product_name: "DVX-3266-4K",                        product_slug: "dvx-3266-4k",                      remove_from_product_family: "All-In-One Presentation Switchers",  remove_from_product_family_slug: "all-in-one-presentation-switchers", new_product_family: "DVX 4K60 (Up to 8x4 +2)",                            new_product_family_slug: "dvx-4k60-up-to-8x4-2"},
      { product_name: "DVX-2210HD",                         product_slug: "dvx-2210hd",                       remove_from_product_family: "All-In-One Presentation Switchers",  remove_from_product_family_slug: "all-in-one-presentation-switchers", new_product_family: "DVX HD (Up to 10x4 +2)",                             new_product_family_slug: "dvx-hd-up-to-10x4-2"},
      { product_name: "DVX-2250HD",                         product_slug: "dvx-2250hd",                       remove_from_product_family: "All-In-One Presentation Switchers",  remove_from_product_family_slug: "all-in-one-presentation-switchers", new_product_family: "DVX HD (Up to 10x4 +2)",                             new_product_family_slug: "dvx-hd-up-to-10x4-2"},
      { product_name: "DVX-2255HD",                         product_slug: "dvx-2255hd",                       remove_from_product_family: "All-In-One Presentation Switchers",  remove_from_product_family_slug: "all-in-one-presentation-switchers", new_product_family: "DVX HD (Up to 10x4 +2)",                             new_product_family_slug: "dvx-hd-up-to-10x4-2"},
      { product_name: "DVX-3250HD",                         product_slug: "dvx-3250hd",                       remove_from_product_family: "All-In-One Presentation Switchers",  remove_from_product_family_slug: "all-in-one-presentation-switchers", new_product_family: "DVX HD (Up to 10x4 +2)",                             new_product_family_slug: "dvx-hd-up-to-10x4-2"},
      { product_name: "DVX-3255HD",                         product_slug: "dvx-3255hd",                       remove_from_product_family: "All-In-One Presentation Switchers",  remove_from_product_family_slug: "all-in-one-presentation-switchers", new_product_family: "DVX HD (Up to 10x4 +2)",                             new_product_family_slug: "dvx-hd-up-to-10x4-2"},
      { product_name: "DVX-3256HD",                         product_slug: "dvx-3256hd",                       remove_from_product_family: "All-In-One Presentation Switchers",  remove_from_product_family_slug: "all-in-one-presentation-switchers", new_product_family: "DVX HD (Up to 10x4 +2)",                             new_product_family_slug: "dvx-hd-up-to-10x4-2"},
      { product_name: "NCITE-813",                          product_slug: "ncite-813",                        remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Incite 4K60 (Up to 6x1 +2)",                         new_product_family_slug: "incite-4k60-up-to-6x1-2"},
      { product_name: "NCITE-813A",                         product_slug: "ncite-813a",                       remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Incite 4K60 (Up to 6x1 +2)",                         new_product_family_slug: "incite-4k60-up-to-6x1-2"},
      { product_name: "NCITE-813AC",                        product_slug: "ncite-813ac",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Incite 4K60 (Up to 6x1 +2)",                         new_product_family_slug: "incite-4k60-up-to-6x1-2"},
      { product_name: "CTC-1402",                           product_slug: "ctc-1402",                         remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "CTC (4K60 6x1) Switching & Transport Kit w/ USB-C",  new_product_family_slug: "ctc-4k60-6x1-switching-transport-kit-w-usb-c"},
      { product_name: "CTP-1301",                           product_slug: "ctp-1301",                         remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "CTP (4K30 4x1) Switching & Transport Kit",           new_product_family_slug: "ctp-4k30-4x1-switching-transport-kit"},
      { product_name: "VPX-1401",                           product_slug: "vpx-1401",                         remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "VPX (4K60 4x1 +1)",                                  new_product_family_slug: "vpx-4k60-4x1-1"},
      { product_name: "VPX-1701",                           product_slug: "vpx-1701",                         remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "VPX (4K60 7x1 +1)",                                  new_product_family_slug: "vpx-4k60-7x1-1"},
      { product_name: "SDX-414-DX",                         product_slug: "sdx-414-dx",                       remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "SDX (4K30 4x1 +1)",                                  new_product_family_slug: "sdx-4k30-4x1-1"},
      { product_name: "SDX-514M-DX",                        product_slug: "sdx-514m-dx",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "SDX (4K30 5x1 +1)",                                  new_product_family_slug: "sdx-4k30-5x1-1"},
      { product_name: "DGX800-ENC",                         product_slug: "dgx800-enc",                       remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "8x8",                                                new_product_family_slug: "8x8",                       grand_parent_product_family: "Enclosures (w/ Central Controllers)", grand_parent_product_family_slug: "enclosures-w-central-controllers"},
      { product_name: "DGX1600-ENC",                        product_slug: "dgx1600-enc",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "16x16",                                              new_product_family_slug: "16x16",                     grand_parent_product_family: "Enclosures (w/ Central Controllers)", grand_parent_product_family_slug: "enclosures-w-central-controllers"},
      { product_name: "DGX3200-ENC",                        product_slug: "dgx3200-enc",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "32x32",                                              new_product_family_slug: "32x32",                     grand_parent_product_family: "Enclosures (w/ Central Controllers)", grand_parent_product_family_slug: "enclosures-w-central-controllers"},
      { product_name: "DGX6400-ENC",                        product_slug: "dgx6400-enc",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "64x64",                                              new_product_family_slug: "64x64",                     grand_parent_product_family: "Enclosures (w/ Central Controllers)", grand_parent_product_family_slug: "enclosures-w-central-controllers"},
      { product_name: "DGX800/1600/3200-CPU",               product_slug: "dgx800-1600-3200-cpu",             remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "CPU Upgrade Kit",                                    new_product_family_slug: "cpu-upgrade-kit",           grand_parent_product_family: "Enclosures (w/ Central Controllers)", grand_parent_product_family_slug: "enclosures-w-central-controllers"},
      { product_name: "DGX-I-DXFP-4K60",                    product_slug: "dgx-i-dxfp-4k60",                  remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-I-DXL-4K60",                     product_slug: "dgx-i-dxl-4k60",                   remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-I-HDMI-4K60",                    product_slug: "dgx-i-hdmi-4k60",                  remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-O-DXFP-4K60",                    product_slug: "dgx-o-dxfp-4k60",                  remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-O-DXL-4K60",                     product_slug: "dgx-o-dxl-4k60",                   remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-O-HDMI-4K60",                    product_slug: "dgx-o-hdmi-4k60",                  remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DX-RX-4K60",                         product_slug: "dx-rx-4k60",                       remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DX-TX-4K60",                         product_slug: "dx-tx-4k60",                       remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DXFP-RX-4K60",                       product_slug: "dxfp-rx-4k60",                     remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DXFP-TX-4K60",                       product_slug: "dxfp-tx-4k60",                     remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DXL-RX-4K60",                        product_slug: "dxl-rx-4k60",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DXL-TX-4K60",                        product_slug: "dxl-tx-4k60",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "NMX-DEC-N2422A Decoder",             product_slug: "nmx-dec-n2422a-decoder",           remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "NMX-DEC-N2424A Decoder",             product_slug: "nmx-dec-n2424a-decoder",           remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "NMX-ENC-N2412A Encoder",             product_slug: "nmx-enc-n2412a-encoder",           remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "NMX-ENC-N2412A-C Encoder Card",      product_slug: "nmx-enc-n2412a-c-encoder-card",    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "NMX-WP-N2410 Windowing Processor",   product_slug: "nmx-wp-n2410-windowing-processor", remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K60 Cards and Endpoints",                           new_product_family_slug: "4k60-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "NMX-DEC-N2322 Decoder",              product_slug: "nmx-dec-n2322-decoder",            remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K30 Cards and Endpoints",                           new_product_family_slug: "4k30-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "NMX-ENC-N2312 Encoder",              product_slug: "nmx-enc-n2312-encoder",            remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K30 Cards and Endpoints",                           new_product_family_slug: "4k30-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "NMX-ENC-N2312-C Encoder Card",       product_slug: "nmx-enc-n2312-c-encoder-card",     remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K30 Cards and Endpoints",                           new_product_family_slug: "4k30-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "NMX-ENC-N2315-WP Wallplate Encoder", product_slug: "nmx-enc-n2315-wp-wallplate-encoder", remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                new_product_family: "4K30 Cards and Endpoints",                           new_product_family_slug: "4k30-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "NMX-ENC-N2412A Encoder",             product_slug: "nmx-enc-n2412a-encoder",           remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K30 Cards and Endpoints",                           new_product_family_slug: "4k30-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "NMX-ENC-N2412A-C Encoder Card",      product_slug: "nmx-enc-n2412a-c-encoder-card",    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "4K30 Cards and Endpoints",                           new_product_family_slug: "4k30-cards-and-endpoints",  grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-I-DVI",                          product_slug: "dgx-i-dvi",                        remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "HD Cards and Endpoints",                             new_product_family_slug: "hd-cards-and-endpoints",    grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-I-DXF-MMD",                      product_slug: "dgx-i-dxf-mmd",                    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "HD Cards and Endpoints",                             new_product_family_slug: "hd-cards-and-endpoints",    grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-I-DXF-MMS",                      product_slug: "dgx-i-dxf-mms",                    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "HD Cards and Endpoints",                             new_product_family_slug: "hd-cards-and-endpoints",    grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-I-DXF-SMD",                      product_slug: "dgx-i-dxf-smd",                    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "HD Cards and Endpoints",                             new_product_family_slug: "hd-cards-and-endpoints",    grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-I-DXF-SMS",                      product_slug: "dgx-i-dxf-sms",                    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "HD Cards and Endpoints",                             new_product_family_slug: "hd-cards-and-endpoints",    grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-I-DXL",                          product_slug: "dgx-i-dxl",                        remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "HD Cards and Endpoints",                             new_product_family_slug: "hd-cards-and-endpoints",    grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-O-DVI",                          product_slug: "dgx-o-dvi",                        remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "HD Cards and Endpoints",                             new_product_family_slug: "hd-cards-and-endpoints",    grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-O-DXF-MMD",                      product_slug: "dgx-o-dxf-mmd",                    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "HD Cards and Endpoints",                             new_product_family_slug: "hd-cards-and-endpoints",    grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-O-DXF-MMS",                      product_slug: "dgx-o-dxf-mms",                    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "HD Cards and Endpoints",                             new_product_family_slug: "hd-cards-and-endpoints",    grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-O-DXF-SMD",                      product_slug: "dgx-o-dxf-smd",                    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "HD Cards and Endpoints",                             new_product_family_slug: "hd-cards-and-endpoints",    grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-O-DXF-SMS",                      product_slug: "dgx-o-dxf-sms",                    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "HD Cards and Endpoints",                             new_product_family_slug: "hd-cards-and-endpoints",    grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-O-DXL",                          product_slug: "dgx-o-dxl",                        remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "HD Cards and Endpoints",                             new_product_family_slug: "hd-cards-and-endpoints",    grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-AIE",                            product_slug: "dgx-aie",                          remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Audio Cards",                                        new_product_family_slug: "audio-cards",               grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX3200-ASB-DAN",                    product_slug: "dgx3200-asb-dan",                  remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Audio Cards",                                        new_product_family_slug: "audio-cards",               grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX800/1600-ASB",                    product_slug: "dgx3200-asb-dan",                  remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Audio Cards",                                        new_product_family_slug: "audio-cards",               grand_parent_product_family: "Modular Switching Systems",           grand_parent_product_family_slug: "modular-switching-systems"},
      { product_name: "DGX-I-DXFP-4K60",                    product_slug: "dgx-i-dxfp-4k60",                  remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DXLink Fiber (>100m)",                               new_product_family_slug: "dxlink-fiber-100m",         grand_parent_product_family: "A/V Distance Transport Solutions",    grand_parent_product_family_slug: "a-v-distance-transport-solutions"},
      { product_name: "DGX-O-DXFP-4K60",                    product_slug: "dgx-o-dxfp-4k60",                  remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DXLink Fiber (>100m)",                               new_product_family_slug: "dxlink-fiber-100m",         grand_parent_product_family: "A/V Distance Transport Solutions",    grand_parent_product_family_slug: "a-v-distance-transport-solutions"},
      { product_name: "DGX-I-DXL",                          product_slug: "dgx-i-dxl",                        remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DXLink U/STP (<100m)",                               new_product_family_slug: "dxlink-u-stp-100m",         grand_parent_product_family: "A/V Distance Transport Solutions",    grand_parent_product_family_slug: "a-v-distance-transport-solutions"},
      { product_name: "DGX-I-DXL-4K",                       product_slug: "dgx-i-dxl-4k",                     remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DXLink U/STP (<100m)",                               new_product_family_slug: "dxlink-u-stp-100m",         grand_parent_product_family: "A/V Distance Transport Solutions",    grand_parent_product_family_slug: "a-v-distance-transport-solutions"},
      { product_name: "DGX-I-DXL-4K60",                     product_slug: "dgx-i-dxl-4k60",                   remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DXLink U/STP (<100m)",                               new_product_family_slug: "dxlink-u-stp-100m",         grand_parent_product_family: "A/V Distance Transport Solutions",    grand_parent_product_family_slug: "a-v-distance-transport-solutions"},
      { product_name: "DGX-O-DXL",                          product_slug: "dgx-o-dxl",                        remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DXLink U/STP (<100m)",                               new_product_family_slug: "dxlink-u-stp-100m",         grand_parent_product_family: "A/V Distance Transport Solutions",    grand_parent_product_family_slug: "a-v-distance-transport-solutions"},
      { product_name: "DGX-O-DXL-4K",                       product_slug: "dgx-o-dxl-4k",                     remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DXLink U/STP (<100m)",                               new_product_family_slug: "dxlink-u-stp-100m",         grand_parent_product_family: "A/V Distance Transport Solutions",    grand_parent_product_family_slug: "a-v-distance-transport-solutions"},
      { product_name: "DGX-O-DXL-4K60",                     product_slug: "dgx-o-dxl-4k60",                   remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DXLink U/STP (<100m)",                               new_product_family_slug: "dxlink-u-stp-100m",         grand_parent_product_family: "A/V Distance Transport Solutions",    grand_parent_product_family_slug: "a-v-distance-transport-solutions"},
      { product_name: "DXL-TX-4K60",                        product_slug: "dxl-tx-4k60",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DXLite U/STP (<70m)",                                new_product_family_slug: "dxlink-u-stp-100m",         grand_parent_product_family: "A/V Distance Transport Solutions",    grand_parent_product_family_slug: "a-v-distance-transport-solutions"},
      { product_name: "DXL-RX-4K60",                        product_slug: "dxl-rx-4k60",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DXLite U/STP (<70m)",                                new_product_family_slug: "dxlink-u-stp-100m",         grand_parent_product_family: "A/V Distance Transport Solutions",    grand_parent_product_family_slug: "a-v-distance-transport-solutions"},
      { product_name: "PR-WP-412",                          product_slug: "pr-wp-412",                        remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Window Processing",                                  new_product_family_slug: "window-processing",         grand_parent_product_family: "Traditional A/V Distribution",        grand_parent_product_family_slug: "traditional-a-v-distribution"},
      { product_name: "PR-WP-412",                          product_slug: "pr-wp-412",                        remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Precis (4K60 4x1 + 1)",                              new_product_family_slug: "precis-4k60-4x1-1",         grand_parent_product_family: "Window Processing",                   grand_parent_product_family_slug: "amx-window-processing-380"},
      { product_name: "AVB-VSTYLE-POLE-MNT",                product_slug: "avb-vstyle-pole-mnt",              remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Mounting",                                           new_product_family_slug: "amx-mounting",              grand_parent_product_family: "Traditional A/V Accessories",         grand_parent_product_family_slug: "traditional-a-v-accessories"},
      { product_name: "AVB-VSTYLE-RMK",                     product_slug: "avb-vstyle-rmk",                   remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Mounting",                                           new_product_family_slug: "amx-mounting",              grand_parent_product_family: "Traditional A/V Accessories",         grand_parent_product_family_slug: "traditional-a-v-accessories"},
      { product_name: "AVB-VSTYLE-SURFACE-MNT",             product_slug: "avb-vstyle-surface-mnt",           remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Mounting",                                           new_product_family_slug: "amx-mounting",              grand_parent_product_family: "Traditional A/V Accessories",         grand_parent_product_family_slug: "traditional-a-v-accessories"},
      { product_name: "PC1",                                product_slug: "pc1",                              remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Power",                                              new_product_family_slug: "amx-power",                 grand_parent_product_family: "Traditional A/V Accessories",         grand_parent_product_family_slug: "traditional-a-v-accessories"},
      { product_name: "PDXL-2",                             product_slug: "pdxl-2",                           remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Power",                                              new_product_family_slug: "amx-power",                 grand_parent_product_family: "Traditional A/V Accessories",         grand_parent_product_family_slug: "traditional-a-v-accessories"},
      { product_name: "PS-POE-AT-TC",                       product_slug: "ps-poe-at-tc",                     remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Power",                                              new_product_family_slug: "amx-power",                 grand_parent_product_family: "Traditional A/V Accessories",         grand_parent_product_family_slug: "traditional-a-v-accessories"},
      { product_name: "PS3.0",                              product_slug: "ps3-0",                            remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Power",                                              new_product_family_slug: "amx-power",                 grand_parent_product_family: "Traditional A/V Accessories",         grand_parent_product_family_slug: "traditional-a-v-accessories"},
      { product_name: "PS4.4",                              product_slug: "ps4-4",                            remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Power",                                              new_product_family_slug: "amx-power",                 grand_parent_product_family: "Traditional A/V Accessories",         grand_parent_product_family_slug: "traditional-a-v-accessories"},
      { product_name: "PSR5.4",                             product_slug: "psr5-4",                           remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Power",                                              new_product_family_slug: "amx-power",                 grand_parent_product_family: "Traditional A/V Accessories",         grand_parent_product_family_slug: "traditional-a-v-accessories"},
      { product_name: "PSR7-V",                             product_slug: "psr7-v",                           remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Power",                                              new_product_family_slug: "amx-power",                 grand_parent_product_family: "Traditional A/V Accessories",         grand_parent_product_family_slug: "traditional-a-v-accessories"},
      { product_name: "DCE-1 In-Line Controller",           product_slug: "dce-1-in-line-controller",         remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DCE-1 In-Line Controller",                           new_product_family_slug: "dce-1-in-line-controller",  grand_parent_product_family: "EDID Management, Scaling, & Capture", grand_parent_product_family_slug: "edid-management-scaling-capture"},
      { product_name: "SCL-1 Video Scaler",                 product_slug: "scl-1-video-scaler",               remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "SCL-1 Video Scaler",                                 new_product_family_slug: "scl-1-video-scaler",        grand_parent_product_family: "EDID Management, Scaling, & Capture", grand_parent_product_family_slug: "edid-management-scaling-capture"},
      { product_name: "UVC1-4K",                            product_slug: "uvc1-4k",                          remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "UVC1-4K HDMI to USB Capture",                        new_product_family_slug: "uvc1-4k-hdmi-to-usb-capture", grand_parent_product_family: "EDID Management, Scaling, & Capture", grand_parent_product_family_slug: "edid-management-scaling-capture"},
      { product_name: "PR-WP-412",                          product_slug: "pr-wp-412",                        remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Precis (4K60 4x1 + 1)",                              new_product_family_slug: "amx-precis-4k60-4x1-1",     grand_parent_product_family: "HDMI Solutions",                      grand_parent_product_family_slug: "hdmi-solutions"},
      { product_name: "NMX-WP-N2410 Windowing Processor",   product_slug: "nmx-wp-n2410-windowing-processor", remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "N2400 Series (4K60 4x1)",                            new_product_family_slug: "amx-n2400-series-4k60-4x1", grand_parent_product_family: "1G Solutions",                        grand_parent_product_family_slug: "amx-1g-solutions-1203"},
      { product_name: "NMX-WP-N2510 Windowing Processor",   product_slug: "nmx-wp-n2510-windowing-processor", remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "N2000 Series (4K30 4x1)",                            new_product_family_slug: "n2000-series-4k30-4x1",     grand_parent_product_family: "1G Solutions",                        grand_parent_product_family_slug: "amx-1g-solutions-1203"},
      { product_name: "NMX-WP-N1512 Windowing Processor",   product_slug: "nmx-wp-n1512-windowing-processor", remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "N1000 Series (HD 4x1)",                              new_product_family_slug: "amx-n1000-series-hd-4x1",   grand_parent_product_family: "1G Solutions",                        grand_parent_product_family_slug: "amx-1g-solutions-1203"},
      { product_name: "NMX-WP-N3510 Windowing Processor",   product_slug: "nmx-wp-n3510-windowing-processor", remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "N3000 Series (HD 9x1)",                              new_product_family_slug: "amx-n3000-series-hd-9x1",   grand_parent_product_family: "H.264 Solutions",                     grand_parent_product_family_slug: "amx-h-264-solutions-1207"},
      { product_name: "NMX-NVR-N6123",                      product_slug: "nmx-nvr-n6123",                    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Networked Video Recording & Playback",               new_product_family_slug: "networked-video-recording-playback", grand_parent_product_family: "Video Signal Processing",    grand_parent_product_family_slug: "video-signal-processing"},
      { product_name: "HPX-2BTN-8ACC",                      product_slug: "hpx-2btn-8acc",                    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Accessories",                                        new_product_family_slug: "amx-accessories",           grand_parent_product_family: "Architectural Connectivity",          grand_parent_product_family_slug: "architectural-connectivity"},
      { product_name: "CTC-1402",                           product_slug: "ctc-1402",                         remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "CTC (4K60 6x1) Switching & Transport Kit w/ USB-C",  new_product_family_slug: "amx-ctc-4k60-6x1-switching-transport-kit-w-usb-c", grand_parent_product_family: "Scheduling & Collaboration", grand_parent_product_family_slug: "scheduling-collaboration"},
      { product_name: "CTP-1301",                           product_slug: "ctp-1301",                         remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "CTP (4K30 4x1) Switching & Transport Kit",           new_product_family_slug: "amx-ctp-4k30-4x1-switching-transport-kit", grand_parent_product_family: "Scheduling & Collaboration", grand_parent_product_family_slug: "scheduling-collaboration"},
      { product_name: "MKP-106",                            product_slug: "mkp-106",                          remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Massio (Surface Mount)",                             new_product_family_slug: "massio-surface-mount",      grand_parent_product_family: "Keypads",                             grand_parent_product_family_slug: "keypads"},
      { product_name: "MKP-108",                            product_slug: "mkp-108",                          remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Massio (Surface Mount)",                             new_product_family_slug: "massio-surface-mount",      grand_parent_product_family: "Keypads",                             grand_parent_product_family_slug: "keypads"},
      { product_name: "MCP-106",                            product_slug: "mcp-106",                          remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Massio ControlPads (Surface Mount)",                 new_product_family_slug: "massio-controlpads-surface-mount", grand_parent_product_family: "Keypads w/ Controllers",       grand_parent_product_family_slug: "keypads-w-controllers"},
      { product_name: "MCP-108",                            product_slug: "mcp-108",                          remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Massio ControlPads (Surface Mount)",                 new_product_family_slug: "massio-controlpads-surface-mount", grand_parent_product_family: "Keypads w/ Controllers",       grand_parent_product_family_slug: "keypads-w-controllers"},
      { product_name: "TPC-IPAD",                           product_slug: "tpc-ipad",                         remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "TPC-APPLE",                                          new_product_family_slug: "tpc-apple",                 grand_parent_product_family: "Apps",                                grand_parent_product_family_slug: "apps"},
      { product_name: "TPC-ANDROID-TAB",                    product_slug: "tpc-android-tab",                  remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "TPC-ANDROID",                                        new_product_family_slug: "tpc-android",               grand_parent_product_family: "Apps",                                grand_parent_product_family_slug: "apps"},
      { product_name: "TPC-WIN8-TAB",                       product_slug: "tpc-win8-tab",                     remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "TPC-WIN8",                                           new_product_family_slug: "tpc-win8",                  grand_parent_product_family: "Apps",                                grand_parent_product_family_slug: "apps"},
      { product_name: "TPC-BYOD",                           product_slug: "tpc-byod",                         remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "TPC-BYOD",                                           new_product_family_slug: "tpc-byod",                  grand_parent_product_family: "Apps",                                grand_parent_product_family_slug: "apps"},
      { product_name: "NX-1200",                            product_slug: "nx-1200",                          remove_from_product_family: "NetLinx NX Integrated Controllers",  remove_from_product_family_slug: "netlinx-nx-integrated-controllers", new_product_family: "Central Controllers",                                new_product_family_slug: "central-controllers",       grand_parent_product_family: "Control Processing",                  grand_parent_product_family_slug: "control-processing"},
      { product_name: "NX-2200",                            product_slug: "nx-2200",                          remove_from_product_family: "NetLinx NX Integrated Controllers",  remove_from_product_family_slug: "netlinx-nx-integrated-controllers", new_product_family: "Central Controllers",                                new_product_family_slug: "central-controllers",       grand_parent_product_family: "Control Processing",                  grand_parent_product_family_slug: "control-processing"},
      { product_name: "NX-3200",                            product_slug: "nx-3200",                          remove_from_product_family: "NetLinx NX Integrated Controllers",  remove_from_product_family_slug: "netlinx-nx-integrated-controllers", new_product_family: "Central Controllers",                                new_product_family_slug: "central-controllers",       grand_parent_product_family: "Control Processing",                  grand_parent_product_family_slug: "control-processing"},
      { product_name: "NX-4200",                            product_slug: "nx-4200",                          remove_from_product_family: "NetLinx NX Integrated Controllers",  remove_from_product_family_slug: "netlinx-nx-integrated-controllers", new_product_family: "Central Controllers",                                new_product_family_slug: "central-controllers",       grand_parent_product_family: "Control Processing",                  grand_parent_product_family_slug: "control-processing"},
      { product_name: "EXB-IRS4",                           product_slug: "exb-irs4",                         remove_from_product_family: "ICSLan Device Control Boxes",        remove_from_product_family_slug: "icslan-device-control-boxes",       new_product_family: "IO Extenders",                                       new_product_family_slug: "io-extenders",              grand_parent_product_family: "Control Processing",                  grand_parent_product_family_slug: "control-processing"},
      { product_name: "EXB-COM2",                           product_slug: "exb-com2",                         remove_from_product_family: "ICSLan Device Control Boxes",        remove_from_product_family_slug: "icslan-device-control-boxes",       new_product_family: "IO Extenders",                                       new_product_family_slug: "io-extenders",              grand_parent_product_family: "Control Processing",                  grand_parent_product_family_slug: "control-processing"},
      { product_name: "EXB-REL8",                           product_slug: "exb-rel8",                         remove_from_product_family: "ICSLan Device Control Boxes",        remove_from_product_family_slug: "icslan-device-control-boxes",       new_product_family: "IO Extenders",                                       new_product_family_slug: "io-extenders",              grand_parent_product_family: "Control Processing",                  grand_parent_product_family_slug: "control-processing"},
      { product_name: "EXB-IO8",                            product_slug: "exb-io8",                          remove_from_product_family: "ICSLan Device Control Boxes",        remove_from_product_family_slug: "icslan-device-control-boxes",       new_product_family: "IO Extenders",                                       new_product_family_slug: "io-extenders",              grand_parent_product_family: "Control Processing",                  grand_parent_product_family_slug: "control-processing"},
      { product_name: "EXB-MP1",                            product_slug: "exb-mp1",                          remove_from_product_family: "ICSLan Device Control Boxes",        remove_from_product_family_slug: "icslan-device-control-boxes",       new_product_family: "IO Extenders",                                       new_product_family_slug: "io-extenders",              grand_parent_product_family: "Control Processing",                  grand_parent_product_family_slug: "control-processing"},
      { product_name: "CC-C13-C14",                         product_slug: "cc-c13-c14",                       remove_from_product_family: "Equipment Protection",               remove_from_product_family_slug: "equipment-protection",              new_product_family: "Other",                                              new_product_family_slug: "amx-other",                 grand_parent_product_family: "Control Accessories",                 grand_parent_product_family_slug: "control-accessories"},
      { product_name: "CC-C14-NEMA",                        product_slug: "cc-c14-nema",                      remove_from_product_family: "Equipment Protection",               remove_from_product_family_slug: "equipment-protection",              new_product_family: "Other",                                              new_product_family_slug: "amx-other",                 grand_parent_product_family: "Control Accessories",                 grand_parent_product_family_slug: "control-accessories"},
      { product_name: "CC-NIRC",                            product_slug: "cc-nirc",                          remove_from_product_family: "IR Emitter Cables",                  remove_from_product_family_slug: "ir-emitter-cables",                 new_product_family: "Other",                                              new_product_family_slug: "amx-other",                 grand_parent_product_family: "Control Accessories",                 grand_parent_product_family_slug: "control-accessories"},
      { product_name: "PC1",                                product_slug: "pc1",                              remove_from_product_family: "Contact Closure Interfaces",         remove_from_product_family_slug: "contact-closure-interfaces",        new_product_family: "Other",                                              new_product_family_slug: "amx-other",                 grand_parent_product_family: "Control Accessories",                 grand_parent_product_family_slug: "control-accessories"},
      { product_name: "MCP-106",                            product_slug: "mcp-106",                          remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Massio ControlPads (Surface Mount)",                 new_product_family_slug: "amx-massio-controlpads-surface-mount", grand_parent_product_family: "Controllers w/ User Interfaces",       grand_parent_product_family_slug: "controllers-w-user-interfaces"},
      { product_name: "MCP-108",                            product_slug: "mcp-108",                          remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Massio ControlPads (Surface Mount)",                 new_product_family_slug: "amx-massio-controlpads-surface-mount", grand_parent_product_family: "Controllers w/ User Interfaces",       grand_parent_product_family_slug: "controllers-w-user-interfaces"},
      { product_name: "NCITE-813",                          product_slug: "ncite-813",                        remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Incite",                                             new_product_family_slug: "incite",                    grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "NCITE-813A",                         product_slug: "ncite-813a",                       remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Incite",                                             new_product_family_slug: "incite",                    grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "NCITE-813AC",                        product_slug: "ncite-813ac",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Incite",                                             new_product_family_slug: "incite",                    grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "DXL-RX-4K60",                        product_slug: "dxl-rx-4k60",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Incite",                                             new_product_family_slug: "incite",                    grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "DXL-TX-4K60",                        product_slug: "dxl-tx-4k60",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Incite",                                             new_product_family_slug: "incite",                    grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "NSS-RPM",                            product_slug: "nss-rpm",                          remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Rapid Project Maker (RPM)",                          new_product_family_slug: "rapid-project-maker-rpm",   grand_parent_product_family: "Configuration & Management Software", grand_parent_product_family_slug: "configuration-management-software"},
      { product_name: "NetLinx Studio",                     product_slug: "netlinx-studio",                   remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "NetLinx Studio",                                     new_product_family_slug: "netlinx-studio",            grand_parent_product_family: "Configuration & Management Software", grand_parent_product_family_slug: "configuration-management-software"},
      { product_name: "Driver Design",                      product_slug: "driver-design",                    remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Driver Design",                                      new_product_family_slug: "driver-design",             grand_parent_product_family: "Configuration & Management Software", grand_parent_product_family_slug: "configuration-management-software"},
      { product_name: "IREdit",                             product_slug: "iredit",                           remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "IREdit",                                             new_product_family_slug: "iredit",                    grand_parent_product_family: "Configuration & Management Software", grand_parent_product_family_slug: "configuration-management-software"},
      { product_name: "TPDesign5",                          product_slug: "tpdesign5",                        remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "Touch Panel Design",                                 new_product_family_slug: "touch-panel-design",        grand_parent_product_family: "Configuration & Management Software", grand_parent_product_family_slug: "configuration-management-software"},
      { product_name: "DGX800-ENC",                         product_slug: "dgx800-enc",                       remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DGX",                                                new_product_family_slug: "dgx",                       grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "DGX1600-ENC",                        product_slug: "dgx1600-enc",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DGX",                                                new_product_family_slug: "dgx",                       grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "DGX3200-ENC",                        product_slug: "dgx3200-enc",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DGX",                                                new_product_family_slug: "dgx",                       grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "DGX6400-ENC",                        product_slug: "dgx6400-enc",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DGX",                                                new_product_family_slug: "dgx",                       grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "DVX-2265-4K",                        product_slug: "dvx-2265-4k",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DVX",                                                new_product_family_slug: "dvx",                       grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "DVX-3266-4K",                        product_slug: "dvx-3266-4k",                      remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DVX",                                                new_product_family_slug: "dvx",                       grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "DVX-2210HD",                         product_slug: "dvx-2210hd",                       remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DVX",                                                new_product_family_slug: "dvx",                       grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "DVX-2250HD",                         product_slug: "dvx-2250hd",                       remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DVX",                                                new_product_family_slug: "dvx",                       grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "DVX-2255HD",                         product_slug: "dvx-2255hd",                       remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DVX",                                                new_product_family_slug: "dvx",                       grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "DVX-3255HD",                         product_slug: "dvx-3255hd",                       remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DVX",                                                new_product_family_slug: "dvx",                       grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"},
      { product_name: "DVX-3256HD",                         product_slug: "dvx-3256hd",                       remove_from_product_family: "",                                   remove_from_product_family_slug: "",                                  new_product_family: "DVX",                                                new_product_family_slug: "dvx",                       grand_parent_product_family: "Controllers w/ Switching",            grand_parent_product_family_slug: "controllers-w-switching"}
    ]
  end  #  def product_product_families_to_change

  def delete_old_product_families
    slugs = [
      'svsi-networked-av-presentation-switcher',
      'netlinx-nx-integrated-controllers',
      'icslan-device-control-boxes',
      'equipment-protection',
      'ir-emitter-cables',
      'contact-closure-interfaces',
      'digital-switchers-matrix-switchers',
      'solecis-digital-switchers',
      'precis-series-matrix-switchers-windowing-processors',
      'video-accessories',
      'epica-dgx-288',
      'vision-accessories',
      'hydraport-accessories',
      'hydraport-grommets',
      'amx-collaboration-systems',
      'amx-zoom-collaboration-solutions',
      'scheduling-panels',
      'controlpads-keypads',
      'lighting-controls',
      'radia-lighting-control-enclosures',
      'clear-connect-system-dimmers-switches',
      'amx-development-tools',
      'configuration-software',
      'enova-dvx-accessories',
      'dvx',
      'vpx-series-presentation-switchers',
      'enova-dgx-input-boards',
      'enova-dgx-output-boards',
      'enova-dgx-audio-insert-extract-board',
      'enova-dgx-audio-switching-board-kits',
      'dxlink-twisted-pair-transmitters',
      'dxlink-fiber-transmitters',
      'dxlink-twisted-pair-receivers',
      'dxlink-fiber-receivers',
      'dxlink-twisted-pair-power-sourcing-devices',
      'dxlink-accessories',
      'retractables',
      'video',
      'cat-6',
      'usb',
      'power-modules',
      'buttons-acc-bands',
      'pass-thru',
      'blanks',
      'touch-panel-control-apps'
      ]

    puts "-------------DELETING #{slugs.count} OLD PRODUCT FAMILIES------------------"

    slugs.each do |slug|
      product_familiy_to_delete = ProductFamily.where(cached_slug: slug).first

      if product_familiy_to_delete.present?

          begin
            parent = ProductFamily.where(id: product_familiy_to_delete.parent_id).first
          rescue => e
            binding.pry
            puts "Error finding parent pf in deletion process:  #{e.message}".red
          end
          if parent.present?
            puts "Deleting #{product_familiy_to_delete.name} (#{parent.name})".yellow
          else
            puts "Deleting #{product_familiy_to_delete.name}".yellow
          end
          product_familiy_to_delete.delete
      end  #  if product_familiy_to_delete.present?

    end  #  slugs.each do |slug|

  end  #  def delete_old_product_families

  def reassign_product_families
    # these are reassignments are necessary due to the rare occasions when the order of creation and renaming existing product families falls short
    pfs = [
      {slug:"8x8",parent_slug:"enclosures-w-central-controllers", grand_parent_slug: "modular-switching-systems"},
      {slug:"16x16",parent_slug:"enclosures-w-central-controllers", grand_parent_slug: "modular-switching-systems"},
      {slug:"32x32",parent_slug:"enclosures-w-central-controllers", grand_parent_slug: "modular-switching-systems"},
      {slug:"64x64",parent_slug:"enclosures-w-central-controllers", grand_parent_slug: "modular-switching-systems"},
      {slug:"cpu-upgrade-kit",parent_slug:"enclosures-w-central-controllers", grand_parent_slug: "modular-switching-systems"},
      {slug:"4k60-cards-and-endpoints",parent_slug:"modular-switching-systems", grand_parent_slug: "traditional-a-v-distribution"},
      {slug:"4k30-cards-and-endpoints",parent_slug:"modular-switching-systems", grand_parent_slug: "traditional-a-v-distribution"},
      {slug:"hd-cards-and-endpoints",parent_slug:"modular-switching-systems", grand_parent_slug: "traditional-a-v-distribution"},
      {slug:"audio-cards",parent_slug:"modular-switching-systems", grand_parent_slug: "traditional-a-v-distribution"},
      {slug:"traditional-a-v-accessories", parent_slug: "traditional-a-v-distribution"},
      {slug:"hdmi-solutions", parent_slug: "amx-window-processing", grand_parent_slug: "video-signal-processing"},
      {slug:"amx-precis-4k60-4x1-1", parent_slug: "hdmi-solutions", grand_parent_slug: "amx-window-processing"},
      {slug:"precis-4k60-4x2-8x8-4", parent_slug: "fixed-switchers", grand_parent_slug: "traditional-a-v-distribution"},
      {slug:"amx-window-processing", parent_slug: "video-signal-processing"},
      {slug:"architectural-connectivity", parent_slug: nil, position: 5},
      {slug:"amx-acendo-book", parent_slug: "scheduling-collaboration", position: 1},
      {slug:"acendo-core", parent_slug: "scheduling-collaboration", position: 2},
      {slug:"acendo-vibe", parent_slug: "scheduling-collaboration", position: 3},
      {slug:"amx-ctc-4k60-6x1-switching-transport-kit-w-usb-c", parent_slug: "scheduling-collaboration", position: 4},
      {slug:"amx-ctp-4k30-4x1-switching-transport-kit", parent_slug: "scheduling-collaboration", position: 5},
      {slug:"tpc-apple", parent_slug: "apps", position: 2},
      {slug:"tpc-android", parent_slug: "apps", position: 3},
      {slug:"tpc-win8", parent_slug: "apps", position: 4},
      {slug:"tpc-byod", parent_slug: "apps", position: 5},
      {slug:"central-controllers", parent_slug: "control-processing", position: 1},
      {slug:"amx-other", parent_slug: "control-accessories", position: 3},
      {slug:"controllers-w-user-interfaces", parent_slug: "control-processing", position: 4},
      {slug:"amx-massio-controlpads-surface-mount", parent_slug: "controllers-w-user-interfaces", position: 1},
      {slug:"rapid-project-maker-rpm", parent_slug: "configuration-management-software", position: 1},
      {slug:"netlinx-studio", parent_slug: "configuration-management-software", position: 2},
      {slug:"driver-design", parent_slug: "configuration-management-software", position: 3},
      {slug:"iredit", parent_slug: "configuration-management-software", position: 4},
      {slug:"touch-panel-design", parent_slug: "configuration-management-software", position: 5},
      {slug:"controllers-w-switching", parent_slug: "control-processing", position: 5},
      {slug:"cloudworx-manager", parent_slug: "configuration-management-software", position: 6},
      {slug:"amx-dvx", parent_slug: "controllers-w-switching", position: 2},
      {slug:"amx-n2400-series-4k60-4x1", parent_slug: "amx-1g-solutions-1203", grand_parent_slug: "amx-window-processing", position: 1},
      {slug:"n2000-series-4k30-4x1", parent_slug: "amx-1g-solutions-1203", grand_parent_slug: "amx-window-processing", position: 2},
      {slug:"amx-n1000-series-hd-4x1", parent_slug: "amx-1g-solutions-1203", grand_parent_slug: "amx-window-processing", position: 3},
      {slug:"amx-n3000-series-hd-9x1", parent_slug: "amx-h-264-solutions-1207", grand_parent_slug: "amx-window-processing", position: 4}
      ]

      puts "-------------REPARENTING #{pfs.count} PRODUCT FAMILIES------------------"

      pfs.each do |item|
        grand_parent = ProductFamily.where(cached_slug: item[:grand_parent_slug])
        parent = ProductFamily.where(cached_slug: item[:parent_slug])
        pf = ProductFamily.where(cached_slug: item[:slug]).first

        if grand_parent.present?
          new_parent = ProductFamily.where(id: parent.ids, parent_id: grand_parent.ids).first
        else
          new_parent = ProductFamily.where(id: parent.ids).first
        end

        pf.parent = new_parent
        pf.position = item[:position] if item[:position].present?
        pf.save

        if new_parent.nil?
          puts "Reassigned #{pf.name} (#{pf.cached_slug}) to ---> top level (no parent)".green
        else
          puts "Reassigned #{pf.name} (#{pf.cached_slug}) to ---> #{new_parent.name} (#{new_parent.cached_slug})".green
        end

      end  #  pfs.each do |item|

  end  #  def reassign_product_families

  def add_nav_separator_text
    items = [
      {slug: "n2400-series-4k60",                             text: ">----------1G Solutions----------<"},
      {slug: "n3000-series-hd",                               text: ">---------H.264 Solutions--------<"},
      {slug: "n2400-series-4k60-4x1",                         text: ">----------1G Solutions----------<"},
      {slug: "n3000-series-hd-9x1",                           text: ">---------H.264 Solutions--------<"},
      {slug: "incite-4k60-up-to-6x1-2",                       text: ">------------------------------------------<"},
      {slug: "nmx-prs-n7142-4k60-6x2-2-svsi-card-slots",      text: ">------------------------------------------<"},
      {slug: "ctc-4k60-6x1-switching-transport-kit-w-usb-c",  text: ">------------------------------------------<"},
      {slug: "vpx-4k60-4x1-1",                                text: ">------------------------------------------<"},
      {slug: "cpu-upgrade-kit",                               text: ">------------------------------------------<"},
      {slug: "amx-precis-4k60-4x1-1",                         text: ">---------HDMI Solutions---------<"},
      {slug: "amx-n2400-series-4k60-4x1",                     text: ">----------1G Solutions----------<"},
      {slug: "amx-n3000-series-hd-9x1",                       text: ">---------H.264 Solutions--------<"},
      {slug: "controllers-w-user-interfaces",                 text: ">------------------------------------------<"},
      {slug: "cloudworx-manager",                             text: ">------------------------------------------<"}
      ]

    puts "-------------ADDING #{items.count} PRODUCT NAV SEPARATORS------------------"
      items.each do |item|
        pf = ProductFamily.where(cached_slug: item[:slug]).first
        pf.product_nav_separator = item[:text]
        pf.save
        puts "Added nav separator '#{item[:text]}' to #{pf.name} [#{pf.cached_slug}] ".green
      end

  end  #  def add_nav_separator_text

  def create_new_nav_site_setting
    puts "-------------CREATING SITE SETTING USED IN PRODUCT NAV LEVEL COMBINING------------------"
    custom_nav_setting = Setting.find_by_name("family-slugs-to-be-collapsed-in-nav")
    if !custom_nav_setting.present?
      Setting.create(name: "family-slugs-to-be-collapsed-in-nav", brand: amx, setting_type: "string", string_value: "1g-solutions, h-264-solutions, amx-1g-solutions, amx-h-264-solutions, hdmi-solutions, amx-1g-solutions-1203, amx-h-264-solutions-1207")
      puts "Created site setting 'family-slugs-to-be-collapsed-in-nav' ".green
    else
      puts "Site setting 'family-slugs-to-be-collapsed-in-nav' exists".green
    end
  end  #  def create_new_nav_site_setting

end  #  namespace :amx_nav do