class AddApiSwitchesToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :employee_store, :boolean
    add_column :brands, :live_on_this_platform, :boolean

    Brand.all.each do |b|
    	if b.name == 'dbx' || b.name == 'DOD' || b.name == 'DigiTech' || b.name == 'Lexicon'
    		b.employee_store = true
    		b.live_on_this_platform = true
    		b.save
    	elsif b.name == 'Hardwire' || b.name == 'Vocalist'
    		b.live_on_this_platform = true
    	end
    end
  end
end
