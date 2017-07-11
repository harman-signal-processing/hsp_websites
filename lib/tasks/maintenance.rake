namespace :maintain do

  desc "Check online retailer links"
  task :buynow_links => :environment do
    OnlineRetailerLink.to_be_checked.limit(30).each { |link|
      test_and_update(link)
    }
  end

  desc "Check external links for product reviews"
  task :product_review_links => :environment do
    ProductReview.to_be_checked.limit(30).each { |review|
      test_and_update(review)
    }
  end

  def test_and_update(item)
    puts "Testing #{item.url} ..." if Rails.env.development?
    begin
      response = link_test(item.url)
      puts "    Response: #{response.code}" if Rails.env.development?
      if response.success?
        item.update_attributes(
          url: response.effective_url,
          link_checked_at: Time.now,
          link_status: response.code.to_s
        )
      else
        item.update_attributes(
          link_checked_at: Time.now,
          link_status: response.code.to_s
        )
      end
    rescue
      # something bad happened with our link checker, flag it and move on
      item.update_attributes(:link_checked_at => Time.now, :link_status => "500")
    end
    # Don't crash others' sites.
    Rails.env.production? ? sleep(15) : sleep(2)
  end

  def link_test(url)
    Typhoeus.get(
      url,
      followlocation: true,
      timeout: 20,
      headers: {
        "User-Agent" => "Harman link verifier. Contact adam.anderson@harman.com"
      }
    )
  end

end

namespace :jobs do

  desc "Clear out stuck jobs (> 3 attempts)"
  task :clear_stuck => :environment do
    Delayed::Job.where("attempts > 3").destroy_all
  end

end
