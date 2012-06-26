class AddCachedSlugs < ActiveRecord::Migration
  def self.up
    add_column :artists, :cached_slug, :string
    add_index  :artists, :cached_slug, :unique => true
    add_column :brands, :cached_slug, :string
    add_index  :brands, :cached_slug, :unique => true
    add_column :news, :cached_slug, :string
    add_index  :news, :cached_slug, :unique => true
    add_column :online_retailers, :cached_slug, :string
    add_index  :online_retailers, :cached_slug, :unique => true
    add_column :pages, :cached_slug, :string
    add_index  :pages, :cached_slug, :unique => true
    add_column :products, :cached_slug, :string
    add_index  :products, :cached_slug, :unique => true
    add_column :product_documents, :cached_slug, :string
    add_index  :product_documents, :cached_slug, :unique => true
    add_column :product_families, :cached_slug, :string
    add_index  :product_families, :cached_slug, :unique => true
    add_column :product_reviews, :cached_slug, :string
    add_index  :product_reviews, :cached_slug, :unique => true
    add_column :promotions, :cached_slug, :string
    add_index  :promotions, :cached_slug, :unique => true
    add_column :softwares, :cached_slug, :string
    add_index  :softwares, :cached_slug, :unique => true
    add_column :specifications, :cached_slug, :string
    add_index  :specifications, :cached_slug, :unique => true
  end

  def self.down
    remove_column :artists, :cached_slug
    remove_column :brands, :cached_slug
    remove_column :news, :cached_slug
    remove_column :online_retailers, :cached_slug
    remove_column :pages, :cached_slug
    remove_column :products, :cached_slug
    remove_column :product_documents, :cached_slug
    remove_column :product_families, :cached_slug
    remove_column :product_reviews, :cached_slug
    remove_column :promotions, :cached_slug
    remove_column :softwares, :cached_slug
    remove_column :specifications, :cached_slug
  end
end
