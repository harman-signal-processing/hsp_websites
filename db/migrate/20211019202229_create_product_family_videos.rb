class CreateProductFamilyVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :product_families, :accessories_content, :mediumtext

    create_table :product_family_videos do |t|
      t.integer :product_family_id
      t.string :youtube_id
      t.integer :position

      t.timestamps
    end
    add_index :product_family_videos, :product_family_id

    sceptron = ProductFamily.find("vdo-sceptron")
    ProductFamilyVideo.where(product_family: sceptron, youtube_id: "ERCRRFASA64").first_or_create
    ProductFamilyVideo.where(product_family: sceptron, youtube_id: "ylF9L11Z5PY").first_or_create

    fatron = ProductFamily.find("vdo-fatron")
    ProductFamilyVideo.where(product_family: fatron, youtube_id: "7Lu1lOdf-JQ").first_or_create
    ProductFamilyVideo.where(product_family: fatron, youtube_id: "VQlZJkkYsYA").first_or_create

    dotron = ProductFamily.find("vdo-dotron")
    ProductFamilyVideo.where(product_family: dotron, youtube_id: "ntlmno8a8YQ").first_or_create
    ProductFamilyVideo.where(product_family: dotron, youtube_id: "pdHUTa2CHjs").first_or_create

    atomic = ProductFamily.find("vdo-atomic")
    ProductFamilyVideo.where(product_family: atomic, youtube_id: "pVQ3RlBt1bg").first_or_create
    ProductFamilyVideo.where(product_family: atomic, youtube_id: "sTm9EmnQuwI").first_or_create
    ProductFamilyVideo.where(product_family: atomic, youtube_id: "KuACk_qEX50").first_or_create

    atomic = ProductFamily.find("vdo-atomic-dot")
    ProductFamilyVideo.where(product_family: atomic, youtube_id: "sTm9EmnQuwI").first_or_create
    ProductFamilyVideo.where(product_family: atomic, youtube_id: "KuACk_qEX50").first_or_create

    p3 = ProductFamily.find("p3")
    ProductFamilyVideo.where(product_family: p3, youtube_id: "vcM8m5icoP0").first_or_create
    ProductFamilyVideo.where(product_family: p3, youtube_id: "oouJIm8m1sQ").first_or_create
    ProductFamilyVideo.where(product_family: p3, youtube_id: "PLX8PNXe5hN6PFJTGaOA181S0jfPExmGfs").first_or_create
    ProductFamilyVideo.where(product_family: p3, youtube_id: "KLVOGu7244I").first_or_create
    ProductFamilyVideo.where(product_family: p3, youtube_id: "7cEPix7t7mA").first_or_create
    ProductFamilyVideo.where(product_family: p3, youtube_id: "kNW9jyKarNY").first_or_create

  end
end
