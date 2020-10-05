class AddFirmwareNameToProducts < ActiveRecord::Migration[6.0]
  def up
    add_column :products, :firmware_name, :string

    martin = Brand.find "martin"
    link = ""
    Software.where(category: "firmware", version: "", brand: martin).where("link LIKE '%/firmware%'").each do |s|
      link = s.link
      s.product_softwares.each do |ps|
        ps.product.update(firmware_name: s.name)
      end
      s.destroy
    end

    setting = Setting.where(
      brand: martin,
      name: "firmware_page",
      setting_type: "string"
    ).first_or_create

    setting.update(
      string_value: link,
      description: "Auto-generated firmware links on product pages will land here."
    )
  end

  def down
    martin = Brand.find "martin"
    link = martin.firmware_page || "/firmware"

    martin.products.where.not(firmware_name: [nil, ""]).each do |p|
      s = Software.first_or_create(
        name: p.firmware_name,
        category: firmware,
        brand: martin,
        link: link,
        active: true
      )

      s.products << p unless s.products.include?(p)
    end

    Setting.where(
      brand: martin,
      name: "firmware_page"
    ).destroy_all

    remove_column :products, :firmware_name
  end
end
