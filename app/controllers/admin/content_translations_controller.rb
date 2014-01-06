class Admin::ContentTranslationsController < AdminController
  load_and_authorize_resource only: [:index, :list]
  skip_authorization_check only: :combined
  before_filter :get_target_locale

  def index
  end
  
  def list
    @model_class = params[:type].classify
    if @model_class == "ProductReview"
      @records = ProductReview.where("body IS NOT NULL").all
    elsif @model_class.constantize.new.respond_to?(:brand_id)
      @records = @model_class.constantize.where(brand_id: website.brand_id).all
    elsif @model_class.constantize.new.respond_to?(:product_id)
      @records = @model_class.constantize.where(product_id: @brand.products.collect{|p| p.id})
    else
      @records = @model_class.constantize.all
    end
    respond_to do |format|
      format.html
      format.xml { render @records.to_xml }
    end
  end
  
  def combined
    @model_class = params[:type].classify
    @record = @model_class.constantize.find_by_id(params[:id])
    @content_translations = []
    ContentTranslation.fields_to_translate_for(@record, website.brand).each do |field_name|
      content_translation = ContentTranslation.where(
        content_type: @model_class, 
        content_id: @record.id, 
        content_method: field_name, 
        locale: @target_locale).first_or_initialize
      @content_translations << content_translation
    end
    if request.post?
      @content_translations.each do |content_translation|
        content_translation.content = params[:content][content_translation.content_method]
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
