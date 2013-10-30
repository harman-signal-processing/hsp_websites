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
      clinic_admin: false,
      dealer: false,
      distributor: false,
      rso: false,
      rso_admin: false
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
        cannot :assign, MarketingTask
        can :read, WarrantyRegistration
      end
      if user.role?(:queue_admin)
        can :manage, MarketingTask
        can :assign, MarketingTask
        can :manage, MarketingProject
        can :manage, MarketingProjectType
        can :manage, MarketingProjectTypeTask
        can :manage, MarketingAttachment
        can :manage, User, marketing_staff: true
        can :manage, MarketingComment
        can :estimate, MarketingTask
      end
      if user.role?(:marketing_staff)
        can [:read, :create, :update], MarketingTask
        can :destroy, MarketingTask, requestor_id: user.id
        can :manage, MarketingAttachment
        can :create, MarketingComment
        can :manage, MarketingComment, user_id: user.id
        can :estimate, MarketingTask, worker_id: user.id
        # cannot :assign, MarketingTask # Makes it so admin can't assign either
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
      if user.role?(:rso_admin)
        can :update, User do |u|
          u.role?(:rso)
        end
        can :manage, RsoPersonalReport
        can :manage, RsoSetting
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
        can :manage, Setting
        can :manage, ContentTranslation
      end
      if user.role?(:customer_service)
        can :manage, ServiceCenter
        can :manage, Faq
        can :manage, WarrantyRegistration
        can :manage, Dealer
        can :manage, Distributor
        can :read, ToolkitResource
      end
      if user.role?(:rohs)
        can :read, Product
        can :update, :rohs
      end
      if user.role?(:clinic_admin)
        can :manage, Clinic
        can :manage, ClinicProduct
        # can :manage, User do |uzer|
        #   uzer.role?(:clinician) || uzer.role?(:rep)
        # end
        can :read, ClinicianReport
        can :read, ClinicianQuestion
        can :read, RepReport
        can :read, RepQuestion
      end
      if user.role?(:clinician)
        can :manage, Clinic
        can :create, ClinicianReport
        can :manage, ClinicianReport do |cr|
          user.clinics.include?(cr.clinic)
        end
        can :manage, ClinicianQuestion do |cq|
          user.clinics.include?(cq.clinician_report.clinic)
        end
        can :manage, ClinicProduct do |cp|
          user.clinics.include?(cp.clinic)
        end
        can :read, RepReport do |rr|
          user.clinics.include?(rr.clinic)
        end
        can :read, RepQuestion do |rq|
          user.clinics.include?(rq.rep_report.rep_clinic)
        end
      end
      if user.role?(:rep)
        can :read, ToolkitResource, rep: true
        can :manage, OnlineRetailer
        can :manage, OnlineRetailerLink
        can :manage, Dealer
        can :manage, Clinic
        can :create, RepReport
        can :manage, RepReport do |rr|
          user.rep_clinics.include?(rr.clinic)
        end
        can :manage, RepQuestion do |rq|
          user.rep_clinics.include?(rq.rep_report.rep_clinic)
        end
        can :manage, ClinicProduct do |cp|
          user.clinics.include?(cp.clinic)
        end
        can :read, ClinicianReport do |cr|
          user.clinics.include?(cr.clinic)
        end
        can :read, ClinicianQuestion do |cq|
          user.clinics.include?(cq.clinician_report.clinic)
        end
      end
    end
  end
end
