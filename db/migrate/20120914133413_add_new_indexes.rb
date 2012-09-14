class AddNewIndexes < ActiveRecord::Migration
  def change
  	add_index :websites, :url, unique: true
  	add_index :websites, :brand_id
  	add_index :website_locales, [:locale, :website_id]
  	add_index :tweets, :brand_id
  	add_index :tweets, :tweet_id
  	add_index :settings, :brand_id
  	add_index :settings, [:brand_id, :name]
  	add_index :settings, [:brand_id, :name, :locale]
  	add_index :products, :brand_id
  	add_index :products, [:brand_id, :product_status_id]
  	add_index :product_specifications, :product_id 
  	add_index :product_specifications, :specification_id
  	add_index :product_softwares, :product_id
  	add_index :product_softwares, :software_id
  	add_index :product_site_elements, :product_id
  	add_index :product_site_elements, :site_element_id
  	add_index :product_review_products, :product_id 
  	add_index :product_review_products, :product_review_id
  	add_index :product_promotions, :product_id
  	add_index :product_promotions, :promotion_id
  	add_index :product_introductions, :product_id
  	add_index :product_family_products, :product_id 
  	add_index :product_family_products, :product_family_id
  	add_index :product_families, :brand_id
  	add_index :product_families, :parent_id
  	add_index :product_effects, :product_id
  	add_index :product_effects, :effect_id
  	add_index :product_documents, :product_id
  	add_index :product_cabinets, :product_id
  	add_index :product_cabinets, :cabinet_id
  	add_index :product_audio_demos, :product_id
  	add_index :product_audio_demos, :audio_demo_id
  	add_index :product_attachments, :product_id
  	add_index :product_attachments, [:product_id, :primary_photo]
  	add_index :product_amp_models, :product_id
  	add_index :product_amp_models, :amp_model_id
  	add_index :parent_products, :parent_product_id
  	add_index :parent_products, :product_id
  	add_index :pages, :brand_id
  	add_index :pages, :custom_route
  	add_index :online_retailer_links, :product_id
  	add_index :online_retailer_links, :online_retailer_id
  	add_index :online_retailer_links, :brand_id
  	add_index :online_retailer_links, [:online_retailer_id, :brand_id]
  	add_index :online_retailer_links, [:online_retailer_id, :product_id]
  	add_index :online_retailer_users, :online_retailer_id
  	add_index :online_retailer_users, :user_id
  	add_index :news, :brand_id
  	add_index :news_products, :product_id
  	add_index :news_products, :news_id
  	add_index :faqs, :product_id
  	add_index :effects, :effect_type_id
  	add_index :distributors, :country
  	add_index :demo_songs, :product_attachment_id
  	add_index :dealers, :brand_id
  	add_index :dealers, :account_number
  	add_index :dealers, :exclude
  	add_index :dealers, :skip_sync_from_sap
  	add_index :content_translations, [:content_type, :content_id]
  	add_index :content_translations, :content_type
  	add_index :content_translations, :content_id
  	add_index :content_translations, :content_method
  	add_index :content_translations, :locale
  	add_index :brand_distributors, :brand_id
  	add_index :brand_distributors, :distributor_id
  	add_index :blogs, :brand_id
  	add_index :blog_articles, :blog_id
  	add_index :blog_articles, :author_id
  	add_index :audio_demos, :brand_id
  	add_index :artists, :artist_tier_id
  	add_index :artists, :approver_id
  	add_index :artists, :featured
  	add_index :artist_tiers, :invitation_code
  	add_index :artist_tiers, :show_on_artist_page
  	add_index :artist_products, :artist_id 
  	add_index :artist_products, :product_id 
  	add_index :artist_products, [:artist_id, :favorite]
  	add_index :artist_products, [:product_id, :on_tour]
  	add_index :artist_brands, :artist_id
  	add_index :artist_brands, :brand_id
  	add_index :admin_logs, :website_id
  	add_index :admin_logs, :user_id
  end
end
