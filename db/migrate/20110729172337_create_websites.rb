class CreateWebsites < ActiveRecord::Migration
  def self.up
    create_table :websites do |t|
      t.string :url
      t.integer :brand_id
      t.string :folder

      t.timestamps
    end
    # ["DigiTech", "dbx", "Lexicon", "BSS", "Vocalist", "HardWire", "JBL Commercial"]
    Website.create!(:url => "www.digitech.com", :brand_id => 1, :folder => "digitech")
    Website.create!(:url => "digitech.com", :brand_id => 1, :folder => "digitech")
    Website.create!(:url => "www.dbxpro.com", :brand_id => 2, :folder => "dbx")
    Website.create!(:url => "dbxpro.com", :brand_id => 2, :folder => "dbx")
    Website.create!(:url => "www.lexiconpro.com", :brand_id => 3, :folder => "lexicon")
    Website.create!(:url => "lexiconpro.com", :brand_id => 3, :folder => "lexicon")
    Website.create!(:url => "www.bssaudio.com", :brand_id => 4, :folder => "bss")
    Website.create!(:url => "www.bssaudious.com", :brand_id => 4, :folder => "bss")
    Website.create!(:url => "bssaudio.com", :brand_id => 4, :folder => "bss")
    Website.create!(:url => "bssaudious.com", :brand_id => 4, :folder => "bss")
    Website.create!(:url => "www.bss.co.uk", :brand_id => 4, :folder => "bss")
    Website.create!(:url => "www.vocalistpro.com", :brand_id => 5, :folder => "vocalist")
    Website.create!(:url => "vocalistpro.com", :brand_id => 5, :folder => "vocalist")
    Website.create!(:url => "www.hardwirepedals.com", :brand_id => 6, :folder => "hardwire")
    Website.create!(:url => "hardwirepedals.com", :brand_id => 6, :folder => "hardwire")
    Website.create!(:url => "www.jblcommercialproducts.com", :brand_id => 7, :folder => "jbl_commercial")
    Website.create!(:url => "jblcommercialproducts.com", :brand_id => 7, :folder => "jbl_commercial")
    Website.create!(:url => "commercial.jbl.com", :brand_id => 7, :folder => "jbl_commercial")
    Website.create!(:url => "www.commercial.jbl.com", :brand_id => 7, :folder => "jbl_commercial")
  end

  def self.down
    drop_table :websites
  end
end
