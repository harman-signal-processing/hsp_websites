class CreateBrandToolkitContacts < ActiveRecord::Migration
  def up
    create_table :brand_toolkit_contacts do |t|
      t.integer :brand_id
      t.integer :user_id
      t.integer :position

      t.timestamps
    end

    digitech = Brand.find("digitech")
    dod = Brand.find("dod")
    bss = Brand.find("bss")
    dbx = Brand.find("dbx")
    lexicon = Brand.find("lexicon")

    if klimt = User.where(email: "scott.klimt@harman.com").first
    	klimt.job_title = "Market Manager"
    	klimt.save

    	BrandToolkitContact.create(brand_id: digitech.id, user_id: klimt.id)
    	BrandToolkitContact.create(brand_id: dod.id, user_id: klimt.id)
    end

    if cram = User.where(email: "tom.cram@harman.com").first
    	cram.job_title = "Artist Relations / Clinician Manager"
    	cram.save

    	BrandToolkitContact.create(brand_id: digitech.id, user_id: cram.id)
			BrandToolkitContact.create(brand_id: dod.id, user_id: cram.id)
    end

    if gregory = User.where(email: "iain.gregory@harman.com").first
    	gregory.job_title = "Market Manager - Installed Sound"
    	gregory.save

    	BrandToolkitContact.create(brand_id: bss.id, user_id: gregory.id)
			BrandToolkitContact.create(brand_id: dbx.id, user_id: gregory.id, position: 2)
		end

    if kbrown = User.where(email: "kevin.brown@harman.com").first
    	kbrown.job_title = "Training Coordinator"
    	kbrown.save

    	BrandToolkitContact.create(brand_id: bss.id, user_id: kbrown.id)
    end

    if noel = User.where(email: "noel.larson@harman.com").first
    	noel.job_title = "Market Manager - Portable/PA"
    	noel.save 

    	BrandToolkitContact.create(brand_id: bss.id, user_id: noel.id)
			BrandToolkitContact.create(brand_id: dbx.id, user_id: noel.id)
			BrandToolkitContact.create(brand_id: lexicon.id, user_id: noel.id)
    end
  end

  def down
  	drop_table :brand_toolkit_contacts
  end
end
