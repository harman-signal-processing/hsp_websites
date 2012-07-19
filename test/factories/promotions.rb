FactoryGirl.define do
  
  factory :promotion do 
    sequence(:name) {|n| "MIR #{n}"}
    brand
    show_start_on 2.weeks.ago
    show_end_on 2.weeks.from_now
    start_on 2.weeks.ago
    end_on 2.weeks.from_now
    description "Get more info"
    promo_form_file_name "promoform.pdf"
    promo_form_file_size 20000
    promo_form_updated_at 1.day.ago
    promo_form_content_type "application/x-pdf"
    tile_file_name "promotile.jpg"
    tile_file_size 200
    tile_content_type "image/jpeg"
    tile_updated_at 1.day.ago
    post_registration_subject nil
    post_registration_message nil
    send_post_registration_message false
    factory :expired_promotion do
      show_end_on 1.day.ago
      end_on 2.days.ago
    end
  end

  factory :product_promotion do
    product
    promotion
  end  

end