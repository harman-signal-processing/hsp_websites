class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new({
      admin: false,
      engineer: false,
      market_manager: false,
      artist_relations: false,
      customer_service: false,
      online_retailer: false,
      translator: false,
      rohs: false,
      clinician: false,
      rep: false,
      dealer: false,
      distributor: false,
      rso: false
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
    else
      # can :read, :all
      cannot :mangle, Product
      if user.role?(:market_manager)
        can :manage, :all
        cannot :manage, User
        cannot :read, User
        cannot :manage, Website
        cannot :manage, Brand
        cannot :manage, ToolkitResourceType
        cannot :manage, ProductIntroduction
        can :read, WarrantyRegistration
        can :manage, PricingType
        can :manage, ProductPrice
        can :update, Brand
      end
      if user.role?(:marketing_staff)
        can :manage, SupportSubject
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
      end
      if user.role?(:rso)
        can :read, ToolkitResource, rso: true
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
        can :read, ToolkitResource, dealer: true
        can :read, OnlineRetailer
        can :update, OnlineRetailer do |online_retailer|
          user.online_retailers.include?(online_retailer)
        end
        can :manage, OnlineRetailerLink do |online_retailer_link|
          user.online_retailers.include?(online_retailer_link.online_retailer)
        end
      end
      if user.role?(:dealer)
        can :read, ToolkitResource, dealer: true
        can :read, ToolkitResourceType
        can :manage, Dealer do |dealer|
          dealer.users.include?(user)
        end
        cannot :create, Dealer
      end
      if user.role?(:distributor)
        can :read, ToolkitResource, distributor: true
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
        can :manage, Dealer
        can :manage, Distributor
        can :read, ToolkitResource
        can :manage, SupportSubject
        can :manage, RegisteredDownload
      end
      if user.role?(:rohs)
        can :read, Product
        can :update, :rohs
      end
      if user.role?(:clinician)
      end
      if user.role?(:rep)
        can :read, ToolkitResource, rep: true
        can :manage, OnlineRetailer
        can :manage, OnlineRetailerLink
        can :manage, Dealer
      end
      if user.role?(:employee)
        can :read, ToolkitResource
        can :read, ToolkitResourceType
      end
    end
  end
end
