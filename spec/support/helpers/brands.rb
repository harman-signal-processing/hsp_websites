module Features
  module Brands

    def digitech_brand
      @digitech_brand ||= FactoryGirl.create(:digitech_brand)
    end

    def digitech_site
      @digitech_site ||= FactoryGirl.create(:website_with_products, folder: "digitech", brand: digitech_brand)
    end

    def lexicon_brand
      @lexicon_brand ||= FactoryGirl.create(:lexicon_brand)
    end

    def lexicon_site
      @lexicon_site ||= FactoryGirl.create(:website_with_products, folder: "lexicon", brand: lexicon_brand)
    end

    def bss_brand
      @bss_brand ||= FactoryGirl.create(:bss_brand)
    end

    def bss_site
      @bss_site ||= FactoryGirl.create(:website_with_products, folder: "bss", brand: bss_brand)
    end

    def dbx_brand
      @dbx_brand ||= FactoryGirl.create(:dbx_brand)
    end

    def dbx_site
      @dbx_site ||= FactoryGirl.create(:website_with_products, folder: "dbx", brand: dbx_brand)
    end

    def setup_toolkit_brands
      @digitech = digitech_brand
      @digitech_site = digitech_site
      @lexicon = lexicon_brand
      @lexicon_site = lexicon_site
      @bss = bss_brand
      # @bss_site = bss_site
      @dbx = dbx_brand
      @dbx_site = dbx_site
    end

  end
end
