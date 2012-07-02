class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :brand_id
      t.string :tweet_id
      t.string :screen_name
      t.text :content
      t.string :profile_image_url
      t.datetime :posted_at

      t.timestamps
    end
    # Brand.all.each do |brand|
    #   Setting.create(brand_id: brand.id, name: 'twitter_consumer_key', string_value: 'ZeqvC4131S97Ns78avbDw')
    #   Setting.create(brand_id: brand.id, name: 'twitter_consumer_secret', string_value: 'cYkVwqbM4fBLkoy7OKnfMhm8mldk0VJhGCOKTo0Ne9g')
    #   Setting.create(brand_id: brand.id, name: 'twitter_oauth_token', string_value: '15180218-UmGDRl6bc1jRVyePwRphHhFGqw5V61n6xhDm9TYki')
    #   Setting.create(brand_id: brand.id, name: 'twitter_oauth_token_secret', string_value: 'FBRbHAUTEt6G4i2lh3420PTeliq3QsEhQlK1q1k')
    # end
  end
end
