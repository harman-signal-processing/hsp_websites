class AddCurrentVersionIdToSiteElements < ActiveRecord::Migration[7.1]
  def change
    add_column :site_elements, :current_version_id, :integer
    add_index :site_elements, :current_version_id

    SiteElement.select("name, language, brand_id, count(id) as total").group(:name, :language, :brand_id).having("count(id) > ?", 1).order("count(id) DESC").each do |se_group|
      puts "Updating #{se_group.name} (#{se_group.language})..."
      site_elements = SiteElement.where(name: se_group.name, language: se_group.language, brand_id: se_group.brand_id, current_version_id: nil).order(:version, :created_at)
      site_elements.update_all(current_version_id: site_elements.last.id)
    end

    puts "Updating records with only 1 version (this will take a minute)"
    SiteElement.where(current_version_id: nil).each do |se|
      se.update_columns(current_version_id: se.id)
    end
  end
end
