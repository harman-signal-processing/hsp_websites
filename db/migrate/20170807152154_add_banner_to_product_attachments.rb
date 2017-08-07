class AddBannerToProductAttachments < ActiveRecord::Migration[5.1]
  def change
    add_column :product_attachments, :full_width_banner_url, :string
    add_column :product_attachments, :show_as_full_width_banner, :boolean, default: false
  end
end
