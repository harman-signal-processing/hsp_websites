class Admin::ContentTranslationsController < AdminController
  load_and_authorize_resource only: [:index, :list]
  skip_authorization_check only: [:combined, :languages]
  before_action :get_target_locale, except: :languages

  def languages
  end

  def index
  end

  def list
    @model_class = params[:type].classify
    klass = ContentTranslation.translatable_classes.find do |ct|
      ct.to_s == @model_class
    end
    @new_instance = klass.new
    if @model_class == "ProductReview"
      @records = ProductReview.joins(:product_review_products).
        where("body IS NOT NULL").
        where(product_review_products: { product_id: website.current_and_discontinued_product_ids })
    elsif website.brand.respond_to?(params[:type])
      @records = website.brand.send(params[:type])
    elsif website.respond_to?(params[:type])
      @records = website.send(params[:type])
    elsif @new_instance.respond_to?(:brand_id)
      @records = klass.where(brand_id: website.brand_id)
    elsif @new_instance.respond_to?(:product_id)
      @records = klass.where(product_id: website.brand.products.collect{|p| p.id})
    elsif @new_instance.respond_to?(:featurable)
      @records = klass.all.select{|r| r if r.featurable.present? && r.featurable.respond_to?(:brand_id) && r.featurable.brand_id == website.brand_id}
    else
      @records = klass.all
    end
    if klass.column_names.include?('name')
      @records = @records.order('name')
    elsif klass.column_names.include?('post_on')
      @records = @records.order('post_on desc').limit(100)
    elsif klass.column_names.include?('review_updated_at') # little hack for product_reviews
      @records = @records.order("product_reviews.created_at desc").limit(100)
    elsif klass.column_names.include?('title')
      @records = @records.order('title').limit(100)
    end
  end

  def combined
    @model_class = params[:type].classify
    @content_translations = []
    @media_translations = []
    klass = ContentTranslation.translatable_classes.find do |ct|
      ct.to_s == @model_class
    end

    @record = klass.find_by_id(params[:id])
    ContentTranslation.fields_to_translate_for(@record, website.brand).each do |field_name|
      unless @record.send(field_name).blank?
        content_translation = ContentTranslation.where(
          content_type: @model_class,
          content_id: @record.id,
          content_method: field_name,
          locale: @target_locale).first_or_initialize
        @content_translations << content_translation
      end
    end
    MediaTranslation.fields_to_translate_for(@record, website.brand).each do |field_name|
      unless @record.send(field_name).blank?
        media_translation = MediaTranslation.where(
          media_type: @model_class,
          media_id: @record.id,
          media_method: field_name,
          locale: @target_locale).first_or_initialize
        @media_translations << media_translation
      end
    end

    @content_translations += ContentTranslation.description_translatables_for(@record, website.brand, @target_locale)
    @content_translations += ContentTranslation.feature_translatables_for(@record, website.brand, @target_locale)

    if request.post?
      @content_translations.each do |content_translation|
        content_translation.content = params[:content]["i#{content_translation.content_id}"][content_translation.content_method]
        if content_translation.valid?
          content_translation.save!
        end
      end
      @media_translations.each do |media_translation|
        if params[:media] &&
          params[:media]["i#{media_translation.media_id}"] &&
          params[:media]["i#{media_translation.media_id}"][media_translation.media_method] &&
          params[:media]["i#{media_translation.media_id}"][media_translation.media_method]["media"]

          media_translation.media = params[:media]["i#{media_translation.media_id}"][media_translation.media_method]["media"]
          if media_translation.valid?
            media_translation.save!
          end
        end
      end
      redirect_to list_admin_content_translations_path(target_locale: @target_locale, type: params[:type]), notice: "Updated successfully."
    end
  end

  private

  def get_target_locale
    @target_locale = params[:target_locale]
  end

end
