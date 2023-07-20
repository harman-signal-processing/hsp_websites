namespace :site_elements do

  desc "Generate report of site resources for auditing"
  task audit_report: :environment do

    # Originally written to audit the Installed category of JBL
    # Can be customized for other categories as needed:
    brand = Brand.find "jbl-professional"
    product_family = brand.product_families.find "installed"

    output_file = File.join(Rails.root, "db", "#{brand.to_param}_#{product_family.to_param}_site_elements.csv")
    overwrite = true
    if File.exist?(output_file)
      overwrite = confirm_overwrite(output_file)
    end

    if overwrite
      generate_report(brand, product_family, output_file)
    end
  end

  def confirm_overwrite(output_file)
    puts "The output file already exists. Do you want to overwrite it?"
    puts "(output file: #{output_file})"
    puts "Overwrite it? (y/n)"

    begin
      input = STDIN.gets.strip.downcase
    end until %w(y n).include?(input)

    if input != 'y'
      puts "Task aborted."
      return false
    end

    return true
  end

  def generate_report(brand, product_family, output_file)
    puts "Loading relevant product ids..."
    product_ids = product_family.current_and_discontinued_products_plus_child_products(brand.default_website).map{|p| p.id}
    puts "  Found #{product_ids.size} #{brand.name} #{product_family.name} product ids"

    i = 0
    CSV.open(output_file, "w") do |csv|
      brand.site_elements.each do |site_element|
        # Filter out private files and older versions
        next unless site_element.show_on_public_site?
        next unless site_element.is_latest_version?

        # Check if this item is associated with any of the products in our target category
        if (site_element.products.pluck(:id) & product_ids).size > 0
          puts "Found: #{site_element.name}"
          attr = [site_element.id, site_element.name, site_element.resource_type]
          if site_element.resource.present?
            attr << site_element.resource.url
          elsif site_element.executable.present?
            attr << site_element.executable.url
          elsif site_element.external_url.present?
            attr << site_element.external_url
          else
            attr << "-"
          end
          attr << site_element.updated_at
          attr << site_element.version
          attr << site_element.language
          attr << site_element.products.map{|p| p.name}.join(",")

          csv << attr

          i += 1
        end
      end
    end

    puts "============================="
    puts "Found #{i} resources"
    puts "============================="
    puts "Output written to #{output_file}"
  end

end
