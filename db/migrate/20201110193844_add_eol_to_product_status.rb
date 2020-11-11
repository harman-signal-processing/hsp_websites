class AddEolToProductStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :product_statuses, :eol, :boolean, default: false
    add_column :product_statuses, :position, :integer

    ProductStatus.where(name: ["Discontinued", "Vintage"]).update(eol: true)
    ProductStatus.where(name: "Limited Availability",
                        show_on_website: true,
                        discontinued: false,
                        shipping: true,
                        eol: true).first_or_create
    ProductStatus.where(name: "In Development").update(position: 0)
    ProductStatus.where(name: "Announced").update(position: 1, name: "Coming Soon")
    ProductStatus.where(name: "In Production").update(position: 2)
    ProductStatus.where(name: "Limited Availability").update(position: 3)
    ProductStatus.where(name: "Discontinued").update(position: 4)
    ProductStatus.where(name: "Vintage").update(position: 5)
    ProductStatus.where(position: nil).update(position: 99)

  end
end
