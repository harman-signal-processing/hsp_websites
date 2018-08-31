# This little hack lets us use the latest version of the country_select gem
# which encourages us to store the country as the 2-letter code instead of
# the name. This is a great idea, but our distributor database is already
# populated with the country names which we need to match.
CountrySelect::FORMATS[:default] = lambda do |country|
  [
    country.name,
    country.name
  ]
end
