module SqlDumper

  def sqldump(opts={})
    config = self.class.connection_config
    fn = Rails.root.join("db", "#{self.class.to_s.downcase}_#{self.id}_#{self.friendly_id}.sql")
    main_opts = "--opt --user=#{config[:username]} --password=#{config[:password]} --replace --complete-insert --no-create-info --skip-add-drop-table #{config[:database]}"
    `mysqldump #{main_opts} #{self.class.table_name} --where="id=#{self.id}" > #{fn}`
    unless !!opts[:skip_associations]
      self.class.reflect_on_all_associations.each do |assoc|
        where = "#{assoc.foreign_key}=#{self.id}"
        if assoc.is_a?(ActiveRecord::Reflection::HasManyReflection) || assoc.is_a?(ActiveRecord::Reflection::HasOneReflection)
          unless assoc.plural_name == self.class.table_name
            if assoc.polymorphic?
              where += " AND #{assoc.foreign_type}='#{self.class}'"
            elsif assoc.class_name == "FriendlyId::Slug"
              where += " AND sluggable_type='#{self.class}'"
            end
            `mysqldump #{main_opts} #{assoc.class_name.constantize.table_name} --where="#{where}" >> #{fn}`
          end
        end
        # ActiveRecord::Reflection::BelongsToReflection should be checked to see if those records exist?
        # ActiveRecord::Reflection::ThroughReflection probably can be skipped
      end
    end
    return fn
  end

end
