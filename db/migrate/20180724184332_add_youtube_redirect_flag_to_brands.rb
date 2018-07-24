class AddYoutubeRedirectFlagToBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :brands, :always_redirect_to_youtube, :boolean, default: false
  end
end
