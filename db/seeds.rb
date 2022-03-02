# Seed the database with
#   bin/rails db:seed
#

# List the individual seed files to load:
#
seed_files = ["customshop"]

seed_files.each do |fn|
  load File.join(Rails.root, 'db', 'seeds', "#{fn}.rb")
end


# Alternatively, load all the seed files
# Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |fn|
#   load fn
# end
#
