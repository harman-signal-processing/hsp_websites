class CreateUsRepRegions < ActiveRecord::Migration
  def up
    create_table :us_rep_regions, force: true do |t|
      t.integer :us_rep_id
      t.integer :us_region_id
      t.integer :brand_id

      t.timestamps
    end

    dbx = Brand.find("dbx")

    rep = UsRep.create(name: 'DOBBS STANFORD CORP', contact: 'toll free:800-474-8238', address: '', city: '', state: '', zip: '', phone: '214-350-9009', fax: '214-956-0167', email: 'dspro@dobbsstanford.com')
    ['ARKANSAS', 'LOUISIANA', 'MISSISSIPPI', 'OKLAHOMA', 'TEXAS', 'FLORIDA', 'TENNESSEE (South West)'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end

    rep = UsRep.create(name: 'HANOUD ASSOCIATES', contact: 'Paul Hanoud', address: '260 Hornbine Road', city: 'Rehoboth', state: 'MA', zip: '02769-2410', phone: '508-677-0701', fax: '508-672-5426', email: 'office@hanoud.com')
    ['CONNECTICUT', 'MASSACHUSETTS', 'MAINE', 'NEW HAMPSHIRE', 'RHODE ISLAND', 'VERMONT'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end

    rep = UsRep.create(name: 'HP MARKETING', contact: 'Andy Connors', address: '4027 E. Emile Zola Avenue', city: 'Phoenix', state: 'AZ', zip: '85032', phone: '602-923-1096', fax: '602-923-1358', email: 'andy@hpmarketingcompany.com')
    ['ARIZONA', 'TEXAS (El Paso)'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end

    rep = UsRep.create(name: 'HP MARKETING', contact: 'Steve Johnson', address: '7340 S Alton Way #G', city: 'Englewood', state: 'CO', zip: '80112', phone: '303-804-9566', fax: '303-804-9662', email: 'steve@hpmarketingcompany.com')
    ['COLORADO', 'NEW MEXICO', 'UTAH', 'WYOMING'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end

    rep = UsRep.create(name: 'Vision 2 Marketing', contact: 'Mick Beisel', address: '2718 Landers Ave', city: 'Nashville', state: 'TN', zip: '37211', phone: '615 255-7606', fax: '615-255-7607', email: 'info@vision2marketing.com')
    ['GEORGIA', 'TENNESSEE (Eastern)'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end

    rep = UsRep.create(name: 'IAV SALES', contact: 'www.iavsales.com', address: '5275 Dixie Hwy Suite B3', city: 'Waterford', state: 'MI', zip: '48329', phone: '248-623-6114', fax: '248-623-6124', email: 'sales@iavsales.com')
		region = UsRegion.where(name: 'MICHIGAN').first_or_create
		UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create

    rep = UsRep.create(name: 'SUNNYLAND MUSIC COMPANY', contact: 'Alan Gaylor', address: '3512 Kalihi St.', city: 'Honolulu', state: 'HI', zip: '96819', phone: '808-521-2552', fax: '', email: 'sunnyland@hawaii.rr.com')
		region = UsRegion.where(name: 'HAWAII').first_or_create
		UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create

    rep = UsRep.create(name: 'NETWORK SALES & MARKETING', contact: 'Tony LoPresti', address: '7568 Market Place Drive', city: 'Eden Prairie', state: 'MN', zip: '55344', phone: '952-941-9800', fax: '952-941-8038', email: 'tony@network-sales.com')
		['ALABAMA', 'NORTH CAROLINA', 'SOUTH CAROLINA', 'TENNESSEE', 'IOWA',
		 'ILLINOIS', 'KANSAS', 'MISSOURI', 'NEBRASKA', 'MINNESOTA', 'NORTH DAKOTA',
		 'SOUTH DAKOTA', 'WISCONSIN'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end

    rep = UsRep.create(name: 'SIGMET UPSTATE', contact: 'Dave Dusman, Karl Peabody', address: '', city: 'Tonawanda', state: 'NY', zip: '', phone: '716-829-0973', fax: '716-877-0807', email: '')
		region = UsRegion.where(name: 'NEW YORK (Upstate)').first_or_create
		UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create

    rep = UsRep.create(name: 'SIGMET SOUTH', contact: 'Ed Portko<br /> Bob Reuther<br /> <a href="mailto:loufarthing@sigmetcorp.com" >Lou Farthing</a><br /> <a href="mailto:gregelwell@sigmetcorp.com"> Greg Elwell</a><br /> Kelly Ireton<br /> <a href="mailto:davehegmann@sigmetcorp.com ">Dave Hegmann</a><br />', address: 'PO Box 995', city: 'Valley Forge', state: 'PA', zip: '19482', phone: '610-783-6666', fax: '610-783-5911', email: '')
    ['DELAWARE', 'MARYLAND', 'PENNSYLVANIA (Eastern)', 'VIRGINIA'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end

    rep = UsRep.create(name: 'SIGMET NORTH', contact: 'Sam Helms, Jim Peters, Clif Barkalow, Mike Mandala, Rebecca Lawrence', address: '289 Hwy 33 / East, Bldg B', city: 'Manalapan', state: 'NJ', zip: '07726', phone: '732-792-1221', fax: '732-792-1305', email: 'sam1374@aol.com')
    ['NEW YORK (City, Long Island)', 'NEW JERSEY'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end

    rep = UsRep.create(name: 'PLUS FOUR MARKETING', contact: 'Jim Matthews', address: '5046 B Commercial Circle', city: 'Concord', state: 'CA', zip: '94520', phone: '925-671-5400', fax: '925-671-4095', email: 'jmathews@plus4mktg.com')
		['ALASKA', 'OREGON', 'IDAHO', 'MONTANA', 'WASHINGTON', 
		 'CALIFORNIA (Northern)', 'NEVADA (Northern)'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end

    rep = UsRep.create(name: 'ROBERT LOUIS ASSOCIATES', contact: 'Robert Louis Podolinski', address: '3358 Babcock Boulevard', city: 'Pittsburgh', state: 'PA', zip: '15237-2422', phone: '412-369-8632', fax: '412-369-8633', email: 'bob@4RLA.com')
		['KENTUCKY (Northern)', 'OHIO', 'PENNSYLVANIA (Western)', 'WEST VIRGINIA'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end
    
    rep = UsRep.create(name: 'SOUND MARKETING', contact: 'Gerry Schrader', address: '10073 S. 76th ave', city: 'Bridgeview', state: 'IL', zip: '60455', phone: '708-598-6888', fax: '708-598-7320', email: 'info@soundmarketingreps.com')
		['KENTUCKY', 'INDIANA'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end

    rep = UsRep.create(name: 'SOUND MARKETING WEST', contact: 'Jerry Klein', address: '21110 Vanowen St', city: 'Canoga Park', state: 'CA', zip: '91304', phone: '818-716-7499', fax: '818-716-7013', email: 'smwinfo@soundmarketingreps.com')
		['CALIFORNIA (Western Southern)', 'NEVADA (Southern)'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end

    rep = UsRep.create(name: 'SOUND MARKETING', contact: 'John Reda', address: '10003 S. Roberts Road', city: 'Palos Hills', state: 'IL', zip: '60465', phone: '708-598-6888', fax: '708-598-7320', email: 'info@soundmarketingreps.com')
		['ILLINOIS (Northern)', 'WISCONSIN (Eastern)'].each do |region_name|
			region = UsRegion.where(name: region_name).first_or_create
			UsRepRegion.where(us_rep_id: rep.id, brand_id: dbx.id, us_region_id: region.id).first_or_create
		end

  end

  def down
  	drop_table :us_rep_regions
  end
end
