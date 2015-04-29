require "test_helper"

describe "API v1 Integration Test" do

	before :each do
    @digitech = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @digitech)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"

    # More stuff needed for API
    @lexicon = FactoryGirl.create(:lexicon_brand)
    @lexicon_site = FactoryGirl.create(:website_with_products, folder: "lexicon", brand: @lexicon)
    @dbx = FactoryGirl.create(:dbx_brand)
    @dbx_site = FactoryGirl.create(:website_with_products, folder: "dbx", brand: @dbx)
    @dod = FactoryGirl.create(:dod_brand)
    @dod_site = FactoryGirl.create(:website_with_products, folder: "dod", brand: @dod)
	end

  # after :each do
  #   DatabaseCleaner.clean
  # end

	describe "brands for employee store" do
		before do
			visit for_employee_store_api_v1_brands_url(host: @website.url)
		end

		it "should list lexicon and dbx brands" do
			page.must_have_content "\"name\":\"#{@lexicon.name}\""
			page.must_have_content "\"name\":\"#{@dbx.name}\""
		end

		it "should provide default url for brands" do
			page.must_have_content "\"url\":\"#{@lexicon_site.url}\""
		end

		it "should provide the product families with product counts" do
			fam = @lexicon.product_families.first
			# save_and_open_page
			page.must_have_content "\"product_family\":{\"id\":#{fam.id},\"name\":\"#{fam.name}\",\"parent_id\":null,\"friendly_id\":\"#{fam.friendly_id}\",\"employee_store_products_count\":5}"
		end
	end

	describe "get an individual brand" do
		before do
			visit api_v1_brand_url(@lexicon.friendly_id, host: @website.url)
		end

		it "should show the brand details" do
			page.must_have_content "\"name\":\"#{@lexicon.name}\""
			page.must_have_content "\"url\":\"#{@lexicon_site.url}\""
		end

		it "should provide the product families with product counts" do
			fam = @lexicon.product_families.first
			page.must_have_content "\"product_family\":{\"id\":#{fam.id},\"name\":\"#{fam.name}\",\"parent_id\":null,\"friendly_id\":\"#{fam.friendly_id}\",\"employee_store_products_count\":5}"
		end
	end

	describe "get brand featured products" do
		before do
			visit api_v1_brand_features_path(@lexicon.friendly_id, host: @website.url)
		end

		it "should have an array of products" do
			page.must_have_content "\"name\":"
		end
	end

	describe "get an individual product without an image" do
		before do
			@product = @digitech.products.first
			visit api_v1_product_url(@product.friendly_id, host: @website.url)
		end	

		it "should have the product description" do
			page.must_have_content @product.description
		end

		it "should have pricing" do
			page.must_have_content "\"msrp\":"
			page.must_have_content "\"harman_employee_price\":"
		end

		it "should have the SAP SKU" do
			page.must_have_content "\"sap_sku\":" 
		end

		it "should have the full URL to the product" do 
			page.must_have_content product_url(@product, host: @product.brand.default_website.url, locale: I18n.default_locale)
		end

		it "should provide a missing image url" do
			page.must_have_content "http://#{@website.url}/assets/missing-image-22x22.png"
			page.must_have_content "http://#{@website.url}/assets/missing-image-128x128.png"
		end
	end

	describe "with image" do
		before do
			@product = @digitech.products.first
			FactoryGirl.create(:product_attachment, product: @product, primary_photo: true)
			visit api_v1_product_url(@product.friendly_id, host: @website.url)
		end

		it "should have the product thumbnail full url" do
			page.must_have_content "http://#{@website.url}" + @product.photo.product_attachment.url(:thumb, timestamp: false)
		end

		it "should have the product image full url" do
			page.must_have_content "http://#{@website.url}" + @product.photo.product_attachment.url(:medium, timestamp: false)
		end
	end

	describe "brand not live on this system" do
		before do
	    	@other_brand = FactoryGirl.create(:brand, employee_store: true, live_on_this_platform: false)
	    	@other_product = FactoryGirl.create(:product, brand: @other_brand, more_info_url: "http://foo.lvh.me/foobar")
			@external_url = "http://brandx.com"
			Brand.any_instance.stubs(:external_url).returns(@external_url)
		end

		it "should have the url to the external product page" do 
			visit api_v1_product_url(@other_product.friendly_id, host: @website.url)
			page.must_have_content @other_product.more_info_url
		end

		it "should have the url to the external brand site" do 
			visit api_v1_brand_url(@other_brand.friendly_id, host: @website.url)
			page.must_have_content @external_url
		end

		it "should show the brand url if the product url is blank" do
			@other_product.more_info_url = nil
			@other_product.save 
			visit api_v1_product_url(@other_product.friendly_id, host: @website.url)
			page.must_have_content @external_url
		end
	end

	describe "get a product family without a product image" do
		before do
			@product_family = @digitech.product_families.first
			@product = @product_family.products.first
			visit api_v1_product_family_url(@product_family.friendly_id, host: @website.url)
		end

		it "should provide the family name" do
			page.must_have_content @product_family.name
		end

		it "should provide a missing thumbnail url" do
			page.must_have_content "http://#{@website.url}/assets/missing-image-22x22.png"
		end
	end


	describe "get a product family with a product image" do
		before do
			@product_family = @digitech.product_families.first
			@product = @product_family.products.first
			FactoryGirl.create(:product_attachment, product: @product, primary_photo: true)
			visit api_v1_product_family_url(@product_family.friendly_id, host: @website.url)
		end

		it "should list the products with thumbnail" do
			page.must_have_content "http://#{@website.url}" + @product.photo.product_attachment.url(:thumb, timestamp: false)
		end
	end

end
