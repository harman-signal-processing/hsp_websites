module Features
  module Brands

    def digitech_brand
      @digitech_brand ||= FactoryBot.create(:digitech_brand)
    end

    def digitech_site
      @digitech_site ||= FactoryBot.create(:website_with_products, folder: "digitech", brand: digitech_brand)
    end

    def lexicon_brand
      @lexicon_brand ||= FactoryBot.create(:lexicon_brand)
    end

    def lexicon_site
      @lexicon_site ||= FactoryBot.create(:website_with_products, folder: "lexicon", brand: lexicon_brand)
    end

    def bss_brand
      @bss_brand ||= FactoryBot.create(:bss_brand)
    end

    def bss_site
      @bss_site ||= FactoryBot.create(:website_with_products, folder: "bss", brand: bss_brand)
    end

    def dbx_brand
      @dbx_brand ||= FactoryBot.create(:dbx_brand)
    end

    def dbx_site
      @dbx_site ||= FactoryBot.create(:website_with_products, folder: "dbx", brand: dbx_brand)
    end

  end
end
