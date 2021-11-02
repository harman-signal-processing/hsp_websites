class CaseStudiesController < ApplicationController
  before_action :set_locale

  def index
    @vertical_market = params[:vertical_market]
    @vertical_market = nil if @vertical_market == "all"
    @asset_type = params[:asset_type]

    case_studies_all = CaseStudy.find_by_website_or_brand(website)
    case_studies = case_studies_all
    locale = I18n.locale.to_s

    is_english_locale = (["en", "en-US", "en-asia"].grep "#{locale}").present?

    if @vertical_market.present?
      case_studies = case_studies.select{|cs| cs[:vertical_markets].find{|t| t[:slug] == @vertical_market}.present?}
    end

    case_studies_en = case_studies.select{|cs| cs[:translations].find{|t| t[:locale] == "en"}.present?}

    if is_english_locale
      @case_studies = case_studies_en.to_a.uniq.sort_by{|cs| cs[:created_at]}.reverse
    else  # find translation for locale and combine them with the english case studies because most case studies are not translated
      case_studies_for_locale = get_case_study_translations_for_locale(case_studies, locale)
      @case_studies = (case_studies_for_locale.to_a + case_studies_en.to_a).uniq.sort_by{|cs| cs[:created_at]}.reverse
    end

    @vertical_markets = get_vertical_market_list(case_studies_all, locale)

    @vertical_case_study_counts = {}
    @vertical_markets.each do |vm|
      @vertical_case_study_counts[vm[:slug]] = case_studies_all.select{|cs| cs[:vertical_markets].find{|t| t[:slug] == vm[:slug]}.present?}.count
    end

    # filter by asset type if requested
    @asset_type_case_study_counts = {}
    @asset_type_case_study_counts[:pdf] = @case_studies.select{|cs| cs[:pdf_url].present?}.count
    @asset_type_case_study_counts[:video] = @case_studies.select{|cs| cs[:youtube_id].present?}.count
    if @asset_type.present? && ["pdf","video"].include?(@asset_type)
      case @asset_type
      when "pdf"
        @case_studies = @case_studies.select{|cs| cs[:pdf_url].present?}
      when "video"
        @case_studies = @case_studies.select{|cs| cs[:youtube_id].present?}
      end
    end  #  if @asset_type.present? && ["pdf","video"].include? @asset_type

    @banner_image = website.brand.site_elements.find_by(name:"Case Studies Banner")
  end  #  def index

  def show
    case_study_slug = params[:slug]
    @case_study = CaseStudy.find_by_slug_and_website_or_brand(case_study_slug, website)

    @products = @case_study[:product_ids].size > 0 ? Product.where(id: @case_study[:product_ids]) : []
  end

  private

  def get_case_study_translations_for_locale(case_studies, locale)
      case_studies_for_locale = case_studies.select{|cs| cs[:translations].find{|t| t[:locale] == locale}.present?}
      case_studies_for_locale = case_studies_for_locale.map{|cs|
        cs.tap do |hash|
          translation = hash[:translations].find{|t| t[:locale] == locale}
          if translation.present?
            hash[:headline] = translation[:headline]
            hash[:content] = translation[:content]
            hash[:slug] = translation[:slug]
          end
        end  #  cs.tap do |hash|
      }  #  case_studies_for_locale = case_studies_for_locale.map{|cs|
  end  #  def get_case_study_translations_for_locale(case_studies, locale)

  def get_vertical_market_list(case_studies, locale)
    vertical_markets = case_studies.map{|cs| cs[:vertical_markets]}
    vertical_markets = vertical_markets.flatten.uniq.sort_by{|v| v[:name]}.select{|v| v[:live] == true}

    is_not_en_locale = !(["en", "en-US", "en-asia"].grep "#{locale}").present?

    # translate vertical market name
    if is_not_en_locale
      vertical_markets = get_vertical_markets_translations(vertical_markets, locale)
    end  #  if is_not_en_locale

    vertical_markets
  end  #  def get_vertical_market_list(case_studies, locale)

  def get_vertical_markets_translations(vertical_markets, locale)
      vertical_markets = vertical_markets.map{|vm|
        vm.tap do |hash|
          translation = hash[:translations].find{|t| t[:locale] == locale}
          if translation.present?
            hash[:name] = translation[:name]
            # hash[:slug] = translation[:slug]
          end
        end  #  cs.tap do |hash|
      }  #  @vertical_markets = @vertical_markets.map{|vm|

      # sort translated vertical market name if not chinese
      vertical_markets.sort_by!{|v| ActiveSupport::Inflector.transliterate v[:name]} unless locale == "zh"
      vertical_markets
  end  #  def get_vertical_markets_translations(vertical_markets)

end  #  class CaseStudiesController < ApplicationController
