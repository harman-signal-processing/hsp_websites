xml.instruct! :xml, version: "1.0"
xml.tag! 'service_centers' do
  for service_center in @service_centers do
    xml.tag! 'service_center' do
      xml.tag! 'name', service_center.name
    	xml.tag! "address", service_center.address
    	xml.tag! "city", service_center.city
    	xml.tag! "state", service_center.state
    	xml.tag! "zip", service_center.zip
    	xml.tag! "telephone", service_center.telephone
    	xml.tag! "fax", service_center.fax
    	xml.tag! "email", service_center.email
    	xml.tag! "account_number", service_center.account_number
    	xml.tag! "website", service_center.website
    	xml.tag! "lat", service_center.lat
    	xml.tag! "lng", service_center.lng
    end
  end
end
