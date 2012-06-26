module AdminHelper
  
  # Need to know what "name" to show for the given record which 
  # could have a :name, :title, or :something_else
  def link_to_translate(object, locale=I18n.default_locale)
    # ct = ContentTranslation.where(:content_type => object.class.to_s,
    #       :content_id => object.id,
    #       :content_method => "hmmm",
    #       :locale => locale)
    link_to(name_for(object), combined_admin_content_translations_path(
                    :locale => I18n.locale, 
                    :target_locale => locale, 
                    :type => object.class.to_s.underscore, 
                    :id => object) )
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
  
end
