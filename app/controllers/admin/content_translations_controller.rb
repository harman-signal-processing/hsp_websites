class Admin::ContentTranslationsController < AdminController
  load_and_authorize_resource only: [:index, :list]
  skip_authorization_check only: :combined
  before_action :get_target_locale

  def index
  end

  def list
    @model_class = params[:type].classify
    klass = ContentTranslation.translatable_classes.find do |ct|
      ct.to_s == @model_class
    end
    @new_instance = klass.new
    if @model_class == "ProductReview"
      @records = ProductReview.where("body IS NOT NULL")
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
    elsif klass.column_names.include?('title')
      @records = @records.order('title').limit(100)
    end
  end

  def combined
    @model_class = params[:type].classify
    @content_translations = []
    klass = ContentTranslation.translatable_classes.find do |ct|
      ct.to_s == @model_class
    end

    if params[:product_id]
      @product = Product.where(id: params[:product_id]).first
      @new_record = klass.new

      klass.where(product_id: params[:product_id]).each do |record|
        ContentTranslation.fields_to_translate_for(@new_record, website.brand).each do |field_name|
          content_translation = ContentTranslation.where(
            content_type: @model_class,
            content_id: record.id,
            content_method: field_name,
            locale: @target_locale).first_or_initialize
          @content_translations << content_translation
        end
      end
    else
      @record = klass.find_by_id(params[:id])
      ContentTranslation.fields_to_translate_for(@record, website.brand).each do |field_name|
        content_translation = ContentTranslation.where(
          content_type: @model_class,
          content_id: @record.id,
          content_method: field_name,
          locale: @target_locale).first_or_initialize
        @content_translations << content_translation
      end
    end
    if request.post?
      @content_translations.each do |content_translation|
        content_translation.content = params[:content]["i#{content_translation.content_id}"][content_translation.content_method]
        if content_translation.valid?
          content_translation.save!
        end
      end
      redirect_to list_admin_content_translations_path(target_locale: @target_locale, type: @model_class), notice: "Updated successfully."
    end
  end

  private

  def get_target_locale
    @target_locale = params[:target_locale]
  end

end
