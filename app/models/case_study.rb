class CaseStudy

  def self.find_by_website_or_brand(website_or_brand)
    if website_or_brand.is_a?(Website)
      brand_name = website_or_brand.brand.name.downcase
    elsif website_or_brand.is_a?(Brand)
      brand_name = website_or_brand.name.downcase
    else
      brand_name = website_or_brand.to_s.downcase
    end

    CaseStudyService.get_case_study_item_list_from_cache(brand_name)
  end

  def self.find_by_slug_and_website_or_brand(slug, website_or_brand)
    case_studies = find_by_website_or_brand(website_or_brand)

    case_study_found_by_translation_slug = case_studies.find do |cs|
      cs[:translations].find{|t| t[:slug] == slug}.present?
    end

    raise ActiveRecord::RecordNotFound if !case_study_found_by_translation_slug

    # replace headline and content with translated version
    case_study = case_study_found_by_translation_slug
    case_study[:headline] = case_study[:translations].find{|t| t[:slug] == slug}[:headline]
    case_study[:content] = case_study[:translations].find{|t| t[:slug] == slug}[:content]

    case_study[:video_only] = !case_study[:content].present? && case_study[:youtube_id].present?

    case_study[:product_ids] = ProductCaseStudy.where(case_study_slug: slug).pluck(:product_id)

    case_study
  end

end
