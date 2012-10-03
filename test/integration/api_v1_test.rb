require "minitest_helper"

describe "API v1 Integration Test" do

	before do
		DatabaseCleaner.start
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
	end

	describe "brands for employee store" do
		before do
			visit for_employee_store_api_v1_brands_url(host: @website.url)
		end

		it "should list lexicon and dbx brands" do
			must_have_content "\"name\":\"#{@lexicon.name}\""
			must_have_content "\"name\":\"#{@dbx.name}\""
		end

		it "should provide default url for brands" do
			must_have_content "\"url\":\"#{@lexicon_site.url}\""
		end

		it "should provide the product families with product counts" do
			fam = @lexicon.product_families.first
			must_have_content "\"product_family\":{\"id\":#{fam.id},\"name\":\"#{fam.name}\",\"parent_id\":null,\"friendly_id\":\"#{fam.friendly_id}\",\"employee_store_products_count\":5}"
		end
	end

	describe "get an individual brand" do
		before do
			visit api_v1_brand_url(@lexicon.friendly_id, host: @website.url)
		end

		it "should show the brand details" do
			must_have_content "\"name\":\"#{@lexicon.name}\""
			must_have_content "\"url\":\"#{@lexicon_site.url}\""
		end

		it "should provide the product families with product counts" do
			fam = @lexicon.product_families.first
			must_have_content "\"product_family\":{\"id\":#{fam.id},\"name\":\"#{fam.name}\",\"parent_id\":null,\"friendly_id\":\"#{fam.friendly_id}\",\"employee_store_products_count\":5}"
		end
	end

	describe "get brand featured products" do
		before do
			visit api_v1_brand_features_path(@lexicon.friendly_id, host: @website.url)
		end

		it "should have an array of products" do
			must_have_content "\"name\":"
		end
	end

	describe "get an individual product without an image" do
		before do
			@product = @digitech.products.first
			visit api_v1_product_url(@product.friendly_id, host: @website.url)
		end	

		it "should have the product description" do
			must_have_content @product.description
		end

		it "should have pricing" do
			must_have_content "\"msrp\":"
			must_have_content "\"harman_employee_price\":"
		end

		it "should have the SAP SKU" do
			must_have_content "\"sap_sku\":" 
		end

		it "should have the full URL to the product" do 
			must_have_content product_url(@product, host: @product.brand.default_website.url, locale: I18n.default_locale)
		end

		it "should provide a missing image url" do
			must_have_content "http://#{@website.url}/assets/missing-image-22x22.png"
			must_have_content "http://#{@website.url}/assets/missing-image-128x128.png"
		end
	end

	describe "with image" do
		before do
			@product = @digitech.products.first
			FactoryGirl.create(:product_attachment, product: @product, primary_photo: true)
			visit api_v1_product_url(@product.friendly_id, host: @website.url)
		end

		it "should have the product thumbnail full url" do
			must_have_content "http://#{@website.url}" + @product.photo.product_attachment.url(:thumb, timestamp: false)
		end

		it "should have the product image full url" do
			must_have_content "http://#{@website.url}" + @product.photo.product_attachment.url(:medium, timestamp: false)
		end
	end

	describe "get a product family without a product image" do
		before do
			@product_family = @digitech.product_families.first
			@product = @product_family.products.first
			visit api_v1_product_family_url(@product_family.friendly_id, host: @website.url)
		end

		it "should provide the family name" do
			must_have_content @product_family.name
		end

		it "should provide a missing thumbnail url" do
			must_have_content "http://#{@website.url}/assets/missing-image-22x22.png"
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
			must_have_content "http://#{@website.url}" + @product.photo.product_attachment.url(:thumb, timestamp: false)
		end
	end

end