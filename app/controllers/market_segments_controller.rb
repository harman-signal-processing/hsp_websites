class MarketSegmentsController < ApplicationController
  before_action :set_locale

  # GET /market_segments
  # GET /market_segments.xml
  def index
    redirect_to product_families_path, status: :moved_permanently
  end

  # GET /market_segments/1
  # GET /market_segments/1.xml
  def show
    @market_segment = MarketSegment.find(params[:id])

    if !website.market_segments.include?(@market_segment)
      redirect_to market_segments_path, status: :moved_permanently and return
    end

    @product_families = @market_segment.market_segment_product_families.map(&:product_family)
    @news = @market_segment.related_news.sort_by(&:post_on).reverse[0,6]
    load_case_studies(@market_segment)

    respond_to do |format|
      format.html { render_template }
      # format.xml  { render xml: @market_segment }
    end
  end

  private

  def load_case_studies(market_segment)
    case_studies_all = CaseStudy.find_by_website_or_brand(website)
    case_studies = case_studies_all
    locale = I18n.locale.to_s

    is_english_locale = (["en", "en-US", "en-asia"].grep "#{locale}").present?

    if market_segment.present?

      if market_segment.cached_slug == "enterprise-av" || market_segment.cached_slug == "corporate"
        case_studies = case_studies.select{|cs| cs[:vertical_markets].find{|t| t[:slug] == "corporate"}.present?}
      end

      if market_segment.cached_slug == "government"
        case_studies = case_studies.select{|cs| cs[:vertical_markets].find{|t| t[:slug] == "government"}.present?}
      end

      if market_segment.cached_slug == "stadiums-arenas"
        case_studies = case_studies.select{|cs| cs[:vertical_markets].find{|t| t[:slug] == "stadiums-arenas"}.present?}
      end

      if market_segment.cached_slug == "bars-restaurants"
        case_studies = case_studies.select{|cs| cs[:vertical_markets].find{|t| t[:slug] == "bars-restaurants"}.present?}
      end

      if market_segment.cached_slug == "convention-centers"
        case_studies = case_studies.select{|cs| cs[:vertical_markets].find{|t| t[:slug] == "convention-centers"}.present?}
      end

      if market_segment.cached_slug == "unified-communication"
        case_studies = case_studies.select{|cs| cs[:vertical_markets].find{|t| t[:slug] == "unified-communication"}.present?}
      end

      if market_segment.cached_slug == "learning-spaces" || market_segment.cached_slug == "education"
        cs_higher_ed = case_studies.select{|cs| cs[:vertical_markets].find{|t| t[:slug] == "higher-education"}.present?}
        cs_k12 = case_studies.select{|cs| cs[:vertical_markets].find{|t| t[:slug] == "k12-primary-education"}.present?}
        case_studies = (cs_higher_ed.take(2) + cs_k12.take(2))
      end  #  if market_segment.cached_slug == "learning-spaces"

    end  #  if market_segment.present?

    case_studies_en = case_studies.select{|cs| cs[:translations].find{|t| t[:locale] == "en"}.present?}

    if is_english_locale
      @case_studies = case_studies_en.to_a.uniq.sort_by{|cs| cs[:created_at]}.reverse
    else  # find translation for locale and combine them with the english case studies because most case studies are not translated
      case_studies_for_locale = get_case_study_translations_for_locale(case_studies, locale)
      @case_studies = (case_studies_for_locale.to_a + case_studies_en.to_a).uniq.sort_by{|cs| cs[:created_at]}.reverse
    end

    @case_studies = @case_studies.take(3) if @case_studies.length > 3

  end  #  load_case_studies

end  #  class MarketSegmentsController < ApplicationController
