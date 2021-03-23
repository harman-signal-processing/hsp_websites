class AddLeadFormSettingToBrands < ActiveRecord::Migration[6.1]
  def change
    add_column :brands, :show_lead_form_on_buy_page, :boolean, default: false

    jblpro = Brand.find "jbl-professional"
    jblpro.update(show_lead_form_on_buy_page: true)

    axys = Brand.find("axys-tunnel")
    axys.update(show_lead_form_on_buy_page: true)

    Setting.where(brand_id: [jblpro.id, axys.id], name: "where_to_buy_extra_content").
      update(name: "where_to_buy_extra_content_DISABLED")
  end
end
