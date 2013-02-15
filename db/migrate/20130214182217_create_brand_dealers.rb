class CreateBrandDealers < ActiveRecord::Migration
  def up
    create_table :brand_dealers do |t|
      t.integer :brand_id
      t.integer :dealer_id

      t.timestamps
    end
    add_index :brand_dealers, :brand_id
    add_index :brand_dealers, :dealer_id

    dbx = Brand.find("dbx")
    bss = Brand.find("bss")
    lex = Brand.find("lexicon")
    dod = Brand.find("dod")
    hwr = Brand.find("hardwire")
    voc = Brand.find("vocalist")
    jbl = Brand.find("jbl-commercial")
    idx = Brand.find("idx")
    dig = Brand.find("digitech")

    completed_accounts = []

    Dealer.all.each do |dealer|
      unless completed_accounts.include?(dealer.account_number)
      	brand_ids = Dealer.where(account_number: dealer.account_number).pluck(:brand_id)
      	brand_ids += [bss.id, lex.id, idx.id, jbl.id] if brand_ids.include?(dbx.id)
        brand_ids += [dod.id, hwr.id, voc.id] if brand_ids.include?(dig.id)

      	brand_ids.uniq.each do |brand_id|
      		BrandDealer.create(brand_id: brand_id, dealer_id: dealer.id)
      	end

      	Dealer.where(account_number: dealer.account_number).where("id != ?", dealer.id).delete_all
        completed_accounts << dealer.account_number
      end
    end

    remove_column :dealers, :brand_id

  end

  def down
  	add_column :dealers, :brand_id, :integer
  	add_index :dealers, :brand_id

  	dig = Brand.find("digitech")
  	dbx = Brand.find("dbx")

  	Dealer.all.each do |dealer|
  		updated_original = false
  		BrandDealer.where(dealer_id: dealer.id).where(brand_id: [dig.id, dbx.id]).each do |bd|
  			if updated_original
  				new_dealer = dealer.dup
  				new_dealer.brand_id = bd.brand_id
  				new_dealer.save
  			else
  				dealer.brand_id = bd.brand_id
  				updated_original = dealer.save
  			end
  		end
  	end

  	drop_table :brand_dealers
  end
end
