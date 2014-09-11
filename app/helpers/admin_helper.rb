module AdminHelper
  
  # Need to know what "name" to show for the given record which 
  # could have a :name, :title, or :something_else
  def link_to_translate(object, locale=I18n.default_locale)
    # ct = ContentTranslation.where(content_type: object.class.to_s,
    #       content_id: object.id,
    #       content_method: "hmmm",
    #       locale: locale)
    link_to(name_for(object), combined_admin_content_translations_path(
                    locale: I18n.locale, 
                    target_locale: locale, 
                    type: object.class.to_s.underscore, 
                    id: object.id) )
  end
  
  def name_for(object)
    if object.respond_to?(:name)  
      object.name
    elsif object.respond_to?(:title)
      object.title
    elsif object.respond_to?(:question)
      "#{object.product.name}: #{object.question}"
    else
      object.to_param
    end
  end
  
  def disable_field_for?(object, attribute)
    return false if can? :manage, :all
    object.disable_field?(attribute)
  end

  def toolkit_collection_select_for(f, related_model)
    case related_model
    when "Promotion"
      f.collection_select :related_id, Promotion.where(brand_id: website.brand_id).where("end_on >= ?", 6.weeks.ago).order(:name), :id, :name
    when "ProductAttachment"
      f.collection_select :related_id, website.brand.products.map{|p| p.images_for("toolkit")}.flatten, :id, :name
    when "ProductDocument"
      f.collection_select :related_id, website.brand.products.map{|p| p.product_documents}.flatten, :id, :name
    when "Product"
      f.collection_select :related_id, website.brand.products.sort_by(&:name), :id, :name
    else
      i = related_model.constantize.new
      if i.respond_to?(:brand_id) && i.respond_to?(:name)
        f.collection_select :related_id, related_model.constantize.where(brand_id: website.brand_id).order(:name), :id, :name
      else
        "error loading related #{related_model.titleize}"
      end
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, srcg: nil)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
  
end
