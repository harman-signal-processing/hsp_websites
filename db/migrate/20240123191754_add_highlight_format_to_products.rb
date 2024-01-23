class AddHighlightFormatToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :highlight_format, :string

    Product.update_all(highlight_format: 'carousel')
  end
end
