FactoryBot.define do
  factory :artist_tier do
  	sequence(:name) {|n| "Tier #{n}"}
  	factory :top_tier do
  		name { "Icon" }
  		show_on_artist_page { true }
  		position { 1 }
  		invitation_code { "ICON" }
  	end
  	factory :second_tier do
  		name { "Master" }
  		show_on_artist_page { true }
  		position { 2 }
  		invitation_code { "MASTER" }
  	end
  	factory :third_tier do
  		name { "Rocker" }
  		show_on_artist_page { true }
  		position { 3 }
  		invitation_code { "ROCKER" }
  	end
  	factory :affiliate_tier do
  		name { "Affiliate" }
  		show_on_artist_page { false }
  	end
  end
end

FactoryBot.define do
  factory :artist do
  	sequence(:name) {|n| "Artist #{n}"}
    bio { "I am the best player this side of the Mississippi." }
    artist_photo { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
    website { "http://facebook.com/supercoolartist" }
    twitter { "supercoolartist" }
    position { 99 }
    featured { false }
    sequence(:email) { |n| "artist#{n}@gmail.com" }
    ## Devise fields: ##
    password { "pass123" }
    password_confirmation { password }
    # encrypted_password
    # reset_password_token
    # reset_password_sent_at
    # remember_created_at
    # sign_in_count
    # current_sign_in_at
    # last_sign_in_at
    # current_sign_in_ip
    # last_sign_in_ip
    # confirmation_token
    # confirmed_at
    # confirmation_sent_at
    ## Optional fields: ##
    # artist_product_photo_file_name
    # artist_product_photo_file_size
    # artist_product_photo_content_type
    # artist_product_photo_updated_at
    # invitation_code
    # main_instrument "Guitar"
    # notable_career_moments
    artist_tier
    transient do
    	skip_unapproval { false }
    	approved { false }
    	initial_brand { Brand.new }
    end
  end
end

FactoryBot.define do
  factory :artist_product do
  	artist
  	product
  	quote { "It be good at musick stuff" }
  	favorite { false }
  end
end

FactoryBot.define do
  factory :artist_brand do
  	artist
  	brand
  	intro { "I like da sounds it makez." }
  end
end
