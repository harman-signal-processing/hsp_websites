class AddMissingSlugs < ActiveRecord::Migration
  def change

    remove_index :slugs, "n_s_s_and_s"

    rename_table :slugs, :friendly_id_slugs
    rename_column :friendly_id_slugs, :name, :slug
    remove_column :friendly_id_slugs, :sequence

    add_index :friendly_id_slugs, [:slug, :sluggable_type]
    add_index :friendly_id_slugs, [:slug, :sluggable_type, :scope], :unique => true
    add_index :friendly_id_slugs, :sluggable_type

    add_column :amp_models, :cached_slug, :string
    add_index  :amp_models, :cached_slug

    add_column :blogs, :cached_slug, :string
    add_index  :blogs, :cached_slug

    add_column :blog_articles, :cached_slug, :string
    add_index  :blog_articles, :cached_slug

    add_column :cabinets, :cached_slug, :string
    add_index  :cabinets, :cached_slug

    add_column :effects, :cached_slug, :string
    add_index  :effects, :cached_slug

    add_column :tone_library_songs, :cached_slug, :string
    add_index  :tone_library_songs, :cached_slug

    add_column :toolkit_resource_types, :cached_slug, :string
    add_index  :toolkit_resource_types, :cached_slug

    AmpModel.all.each{|r| r.save}
    Blog.all.each{|r| r.save}
    BlogArticle.all.each{|r| r.save}
    Cabinet.all.each{|r| r.save}
    Effect.all.each{|r| r.save}
    ToneLibrarySong.all.each{|r| r.save}
    ToolkitResourceType.all.each{|r| r.save}

  end
end
