class Admin::ContentTranslationsController < AdminController
  load_and_authorize_resource only: [:index, :list]
  skip_authorization_check only: :combined
  before_action :get_target_locale

  def index
  end

  def list
    @model_class = params[:type].classify
    @new_instance = @model_class.constantize.new
    if @model_class == "ProductReview"
      @records = ProductReview.where("body IS NOT NULL").all
    elsif @new_instance.respond_to?(:brand_id)
      @records = @model_class.constantize.where(brand_id: website.brand_id).all
    elsif @new_instance.respond_to?(:product_id)
      @records = @model_class.constantize.where(product_id: website.brand.products.collect{|p| p.id})
    else
      @records = @model_class.constantize.all
    end
    if @new_instance.has_attribute?(:name)
      @records = @records.order('name')
    elsif @new_instance.has_attribute?(:title)
      @records = @records.order('title')
    end
    respond_to do |format|
      format.html
      format.xml { render @records.to_xml }
    end
  end

  def combined
    @model_class = params[:type].classify
    @content_translations = []

    if params[:product_id]
      @product = Product.find(params[:product_id])
      @new_record = @model_class.constantize.new

      @model_class.constantize.where(product_id: params[:product_id]).each do |record|
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
      @record = @model_class.constantize.find_by_id(params[:id])
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
