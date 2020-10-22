namespace :maintain do

  desc "Check online retailer links"
  task :buynow_links => :environment do
    OnlineRetailerLink.to_be_checked.limit(30).each do |retailer|
      test_and_update(retailer)
    end
  end

  desc "Check external links for product reviews"
  task :product_review_links => :environment do
    puts "No longer used."
  end

  desc "Check Site Elements links"
  task :site_element_links => :environment do
    SiteElement.to_be_checked(limit: 100).each do |element|
      test_and_update(element)
    end
  end

  desc "Check Product Document links"
  task :product_document_links => :environment do
    ProductDocument.to_be_checked(limit: 100).each do |element|
      test_and_update(element)
    end
  end

  def test_and_update(item)
    puts "Testing #{item.direct_url} ..." if Rails.env.development?
    begin
      response = link_test(item.direct_url)
      puts "    Response: #{response.code}" if Rails.env.development?
      updates = {
        link_checked_at: Time.now,
        link_status: response.code.to_s
      }
      if response.success? && item.is_a?(OnlineRetailerLink)
        updates[:url] = response.effective_url
      end
      item.update( updates )
    rescue
      # something bad happened with our link checker, flag it and move on
      item.update(link_checked_at: Time.now, link_status: "500")
    end
    # Don't crash others' sites.
    Rails.env.production? ? sleep(7) : sleep(2)
  end

  def link_test(url)
    Typhoeus.head(
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
