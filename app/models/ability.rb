class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new({
      admin: false,
      engineer: false,
      market_manager: false,
      marketing_staff: false,
      artist_relations: false,
      customer_service: false,
      online_retailer: false,
      translator: false,
      rohs: false,
      clinician: false,
      rep: false,
      dealer: false,
      distributor: false,
      technician: false,
      super_technician: false,
      rso: false,
      vip_programmers_admin: false
    })
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    if user.role?(:admin)
      can :manage, :all
      can :mangle, Product # only super admins can add video/flash to the product page viewer
      can :disable, OnlineRetailer
      can :manage_warranty_of, Product
    else
      # can :read, :all
      can :read, Software
      can :read, ProductDocument
      cannot :mangle, Product
      can :read, SiteElement, :access_level_id => [false, nil, 0]
      if user.role?(:market_manager)
        can :manage, :all
        cannot :manage, User
        cannot :read, User
        cannot :manage, Website
        cannot :manage, Brand
        cannot :manage, ProductIntroduction
        can :read, WarrantyRegistration
        can :read, ContactMessage
        can :manage, PricingType
        can :manage, ProductPrice
        can :update, Brand
        can :manage, SiteElement
        can :manage, Part
        can :manage, ProductPart
        can :manage_warranty_of, Product
      end
      if user.role?(:marketing_staff)
        can :manage, Product
        can :manage, ProductSpecification
        can :manage, ProductAttachment
        can :manage, ProductDocument
        can :manage, SiteElement
        can :manage, Software
        can :manage, Promotion
        can :manage, SupportSubject
        can :manage, News
        can :read, ContactMessage
        can :read, Stats
        can :manage, Specification
        can :manage, SpecificationGroup
        can :manage_warranty_of, Product
      end
      if user.role?(:sales_admin)
        can :read, Product
        can :update, :harman_employee_pricing
        can :manage, Distributor
        can :manage, Dealer
        can :manage, OnlineRetailer
        can :manage, OnlineRetailerLink
        can :manage, ProductPrice
        can :manage, PricingType
        can :read, WarrantyRegistration
        can :read, ContactMessage
        can :manage, LabelSheet
        can :manage, LabelSheetOrder
      end
      if user.role?(:engineer)
        can :manage, Software
        can :manage, ProductSoftware
        can :manage, SoftwareAttachment
        can :manage, ToneLibrarySong
        can :manage, ToneLibraryPatch
        can :manage, Product do |p|
          p.new_record? || p.product_status.is_hidden?
        end
        cannot :change, ProductStatus
        cannot :create, Product
        cannot :update, :product_name
        cannot :update, :product_keywords
        cannot :update, :product_password
        cannot :update, :product_background
        can :manage, ProductAttachment
        can :manage, ProductDocument
        # can :manage, Specification
        can :manage, ProductSpecification
        can :manage, AmpModel
        can :manage, ProductAmpModel
        can :manage, Cabinet
        can :manage, ProductCabinet
        can :manage, Effect
        can :manage, ProductEffect
        can :manage, EffectType
      end
      if user.role?(:artist_relations)
        can :view, :artist_pricing
        can :manage, Artist
        can :manage, ArtistTier
        can :manage, ArtistBrand
        can :manage, ArtistProduct
        can :manage, ToneLibrarySong
        can :manage, ToneLibraryPatch
      end
      if user.role?(:online_retailer)
        can :read, OnlineRetailer
        can :update, OnlineRetailer do |online_retailer|
          user.online_retailers.include?(online_retailer)
        end
        can :manage, OnlineRetailerLink do |online_retailer_link|
          user.online_retailers.include?(online_retailer_link.online_retailer)
        end
      end
      if user.role?(:dealer)
        can :manage, Dealer do |dealer|
          dealer.users.include?(user)
        end
        cannot :create, Dealer
        can :read, SiteElement do |site_element|
          site_element.access_level.blank? || site_element.access_level.readable_by?(user)
        end
        can :read, Part
        can :read, ProductPart
      end
      if user.role?(:distributor)
        can :read, SiteElement do |site_element|
          site_element.access_level.blank? || site_element.access_level.readable_by?(user)
        end
        can :read, Part
        can :read, ProductPart
      end
      if user.role?(:translator)
        can :read, Setting
        can :copy, Setting
        can :update, Setting do |setting|
          user.locales.include?(setting.locale)
        end
        can :create, Setting do |setting|
          user.locales.include?(setting.locale)
        end
        can :manage, ContentTranslation do |ct|
          user.locales.include?(ct.locale)
        end
        can :manage, SupportSubject do |ss|
          user.locales.include?(ss.locale)
        end
        can :view, SupportSubject
      end
      if user.role?(:customer_service)
        can :manage, ServiceCenter
        can :manage, Faq
        can :manage, WarrantyRegistration
        can :read, ContactMessage
        can :manage, Dealer
        can :manage, Distributor
        can :manage, SupportSubject
        can :manage, RegisteredDownload
        can :manage, DownloadRegistration
        can :manage, Part
        can :manage, ProductPart
        can :manage_warranty_of, Product
      end
      if user.role?(:rohs)
        can :read, Product
        can :update, :rohs
      end
      if user.role?(:clinician)
      end
      if user.role?(:rep)
        can :manage, OnlineRetailer
        can :manage, OnlineRetailerLink
        can :manage, Dealer
      end
      if user.role?(:technician) || user.role?(:super_technician)
        can :read, Part
        can :read, ProductPart
        can :read, SiteElement do |site_element|
          site_element.access_level.blank? || site_element.access_level.readable_by?(user)
        end
      end
      if user.role?(:vip_programmers_admin)
        can :manage, Vip::Certification
        can :manage, Vip::Email
        can :manage, Vip::GlobalRegion
        can :manage, Vip::Location
        can :manage, Vip::LocationGlobalRegion
        can :manage, Vip::LocationServiceArea
        can :manage, Vip::Market
        can :manage, Vip::Phone
        can :manage, Vip::Programmer
        can :manage, Vip::ProgrammerCertification
        can :manage, Vip::ProgrammerEmail
        can :manage, Vip::ProgrammerLocation
        can :manage, Vip::ProgrammerMarket
        can :manage, Vip::ProgrammerPhone
        can :manage, Vip::ProgrammerService
        can :manage, Vip::ProgrammerSiteElement
        can :manage, Vip::ProgrammerSkill
        can :manage, Vip::ProgrammerTraining
        can :manage, Vip::ProgrammerWebsite
        can :manage, Vip::Service
        can :manage, Vip::ServiceArea
        can :manage, Vip::ServiceCategory
        can :manage, Vip::ServiceServiceCategory
        can :manage, Vip::Skill
        can :manage, Vip::Training
        can :manage, Vip::Website
        can :manage, AmxItgNewModuleRequest
        can :manage, Page, custom_route: ["amx-partners-program","amx-partners-program-updates"]
        can :manage, AmxDxlinkDeviceInfo
        can :manage, AmxDxlinkCombo
        can :manage, AmxDxlinkComboAttribute
        can :manage, AmxDxlinkAttributeName
      end  #  if user.role?(:vip_programmers_admin)
    end
  end
end
