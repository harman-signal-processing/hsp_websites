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
      can :disable, OnlineRetailer
    else
      # can :read, :all
      if user.role?(:market_manager)
        can :manage, :all
        cannot :manage, User
        cannot :read, User
        cannot :manage, Website
        cannot :manage, Brand
        can :read, WarrantyRegistration
      end
      if user.role?(:sales_admin)
        can :read, Product
        can :update, :harman_employee_pricing
        can :manage, Distributor
        can :manage, Dealer
        can :manage, OnlineRetailer
        can :manage, OnlineRetailerLink
        can :read, WarrantyRegistration
      end
      if user.role?(:rso_admin)
        can :update, User do |u|
          u.role?(:rso)
        end
        can :manage, RsoPersonalReport
        can :manage, RsoSetting
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
        can :read, OnlineRetailer
        can :update, OnlineRetailer do |online_retailer|
          user.online_retailers.include?(online_retailer)
        end
        can :manage, OnlineRetailerLink do |online_retailer_link|
          user.online_retailers.include?(online_retailer_link.online_retailer)
        end
      end
      if user.role?(:translator)
        can :manage, Setting
        can :manage, ContentTranslation
      end
      if user.role?(:customer_service)
        can :manage, ServiceCenter
        can :manage, Faq
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
