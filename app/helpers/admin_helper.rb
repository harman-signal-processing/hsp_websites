module AdminHelper

  def parent_names_for(object)
    object.ancestors.map{|a| name_for(a)}
  end

  def name_for(object)
    if object.respond_to?(:name)
      object.name
    elsif object.respond_to?(:title)
      object.title
    elsif object.respond_to?(:question)
      "#{object.product.name}: #{object.question}"
    elsif object.respond_to?(:content_name)
      "#{object.product.name} #{object.content_name}"
    else
      object.to_param
    end
  end

  # :nocov:
  def disable_field_for?(object, attribute)
    return false if can? :manage, :all
    object.disable_field?(attribute)
  end

  def link_to_add_fields(name, f, association, options={})
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, srcg: nil)
    end
    link_to(name, '#', class: "add_fields #{options[:class]}", data: {id: id, fields: fields.gsub("\n", "")})
  end
  # :nocov:

end
