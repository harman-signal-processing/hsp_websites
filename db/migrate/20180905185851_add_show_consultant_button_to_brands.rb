class AddShowConsultantButtonToBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :brands, :show_consultant_button, :boolean

    Brand.all.each do |brand|
      brand.update_column(:show_consultant_button, true) unless brand.name.to_s.match(/dbx|digitech|studer/i)
    end
  end
end
