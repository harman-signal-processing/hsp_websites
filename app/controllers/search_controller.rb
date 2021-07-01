class SearchController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_locale

  # The site's search engine:
  def index
    @page_title = t('titles.search_results')
    @query = params[:query]
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
      r unless (
          (r.is_a?(Product) && !r.show_on_website?(website)) ||
          (r.is_a?(Product) && r.product_status.name != "In Production") ||
          (r.is_a?(Product) && !r.locales(website).include?(I18n.locale.to_s)) ||
          (r.has_attribute?(:brand_id) && r.brand_id != website.brand_id) ||
          (r.respond_to?(:belongs_to_this_brand?) && !r.belongs_to_this_brand?(website)) ||
          (r.is_a?(Software) && !r.active)
        )
    end.paginate(page: params[:page], per_page: 10)
  end

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
