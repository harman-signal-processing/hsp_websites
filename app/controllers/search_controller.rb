class SearchController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_locale

  # The site's search engine:
  def index
    @page_title = t('titles.search_results')
    @query = params[:query]
    allowed_punctuation = ["/","-"]
    @query = sanitize_param_value(@query, allowed_punctuation) if @query.present?
    authorize_query!(@query)

    pdf_only_search_results? ? search_pdf_only : search_site_only

  end

  private

  def search_pdf_only
    fetch_thunderstone_pdf_results
    render_template action: 'search_pdf_only'
  end

  def search_site_only
    fetch_thinking_sphinx_results
    render_template action: 'search_site_only'
  end


  def locale_indices
    ['artist', 'news', 'page', 'product_family', 'product', 'product_real_time', 'product_review', 'software'].map do |index|
      "#{index}_#{I18n.locale.to_s.gsub(/\-/, '_')}_core"
    end
  end

  def en_locale_indices_only
    ['artist', 'news', 'page', 'product_family', 'product', 'product_real_time', 'product_review', 'software'].map do |index|
      "#{index}_en_core"
    end
  end

  def include_discontinued_products?
    @include_discontinued_products = !!params[:include_discontinued_products] || !!params[:paginate_include_discontinued_products]
  end

  def pdf_only_search_results?
    # The user wants PDF only search if they check the box or they are clicking the pagination links after they have submitted a PDF only search.
    # If they want to exit the PDF only search they will just need to uncheck the box and click search
    @pdf_only = !!params[:pdf_only] || !!params[:paginate_pdf_only]
  end

  def fetch_thinking_sphinx_results
    query = @query.to_s.gsub(/[\/\\]/, " ")

    if query.empty?
      @results = []
      return false
    end

    ferret_results = thinking_sphinx_results_for_locale(query)

    user_is_searching_for_fg_number = query.downcase.starts_with? "fg"
    if user_is_searching_for_fg_number
      ferret_results = (Product.where("sap_sku like ?","%#{query}%").to_a + ferret_results.to_a).uniq
    end

    @results = ferret_results.select do |r|

      is_product_but_not_for_this_website = (r.is_a?(Product) && !r.show_on_website?(website))

      if include_discontinued_products?
        product_statuses_to_allow = ["In Production", "Coming Soon", "Limited Availability", "Discontinued", "Vintage"]
        is_product_but_not_a_status_to_show = (r.is_a?(Product) && (!product_statuses_to_allow.include?(r.product_status.name)))
      else
        product_statuses_to_allow = ["In Production", "Coming Soon", "Limited Availability"]
        is_product_but_not_a_status_to_show = (r.is_a?(Product) && (!product_statuses_to_allow.include?(r.product_status.name)))
      end
      is_product_but_locale_does_not_match_website = (r.is_a?(Product) && !r.locales(website).include?(I18n.locale.to_s))
      brand_does_not_match_website = (r.has_attribute?(:brand_id) && r.brand_id != website.brand_id)
      does_not_belong_to_website = (r.respond_to?(:belongs_to_this_brand?) && !r.belongs_to_this_brand?(website))
      software_but_not_active = (r.is_a?(Software) && !r.active)
      is_product_review = r.is_a?(ProductReview)
      is_landing_page_with_login = r.is_a?(Page) && r.requires_login?
      is_product_family_page_with_login = r.is_a?(ProductFamily) && r.requires_login?

      # exclude if any of these are true
      r unless (
          is_product_but_not_for_this_website ||
          is_product_but_not_a_status_to_show ||
          is_product_but_locale_does_not_match_website ||
          brand_does_not_match_website ||
          does_not_belong_to_website ||
          software_but_not_active ||
          is_product_review ||
          is_landing_page_with_login ||
          is_product_family_page_with_login
        )

    end.paginate(page: params[:page], per_page: 10)  #  @results = ferret_results.select do |r|

  end  #  def fetch_thinking_sphinx_results

  def thinking_sphinx_results_for_locale(query)

    is_searching_en_locale = (["en", "en-US"].grep "#{I18n.locale.to_s}").present?

    if is_searching_en_locale

      ferret_results = ThinkingSphinx.search(
        ThinkingSphinx::Query.escape(query),
        indices: en_locale_indices_only,
        star: true,
        page: 1, # we'll paginate after filtering out other brand assets
        per_page: 1000
      )

    else  #  not searching en locale

      # Gather search results for chosen local and en locale, then return the combination

      ferret_results_for_other_locales = ThinkingSphinx.search(
        ThinkingSphinx::Query.escape(query),
        indices: locale_indices,
        star: true,
        page: 1, # we'll paginate after filtering out other brand assets
        per_page: 1000
      )

      ferret_results_for_en = ThinkingSphinx.search(
        ThinkingSphinx::Query.escape(query),
        indices: en_locale_indices_only,
        star: true,
        page: 1, # we'll paginate after filtering out other brand assets
        per_page: 1000
      )

      ferret_results = ferret_results_for_other_locales.to_a + ferret_results_for_en.to_a
    end

    ferret_results
  end

  def fetch_thunderstone_pdf_results

    current_page = params[:page].nil? ? 1 : params[:page].to_i
    per_page = 10
    #jump tells Thunderstone where to start the next fetch
    jump = current_page == 1 ? 0 : (current_page-1)*per_page

    if @query.present?
      case website.brand.name.downcase
      when "dbx"
        thunderstone_search_profile = "dbxpro pdfs"
      when "duran audio"
        thunderstone_search_profile = "harmantunnel pdfs"
      else
        thunderstone_search_profile = website.brand.name.downcase + " pdfs"
      end

      sanitized_query = ActionController::Base.helpers.sanitize(@query).gsub(/[\/\\]/, " ")
      @pdf_results = ThunderstoneSearch.find(sanitized_query, thunderstone_search_profile, jump)
      if @pdf_results.blank?
      else
        if @pdf_results[:Summary].present?
          @pdf_results_paginated_list = WillPaginate::Collection.create(current_page, per_page, @pdf_results[:Summary][:TotalNum].to_i) do |pager|
            pager.replace(@pdf_results[:ResultList].to_ary)
          end
        end
      end
    end
  end

end
