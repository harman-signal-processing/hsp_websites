
# Amazon account 'hspwww' access keys:
c = YAML.load_file(File.join(Rails.root, 'config/s3.yml')).symbolize_keys

S3_CREDENTIALS = (c[Rails.env.to_sym]) ? c[Rails.env.to_sym] : c.first

# Cloudfront only seems to work with an S3 bucket OR some other source (not both).
# So, since cdn.harmanpro.com is setup as an alias of assets.harmanpro.com, we need
# a separate CDN for stuff in the S3 buckets...

S3_CLOUDFRONT = 'adn.harmanpro.com' # 'd18nzrj3czoaty.cloudfront.net' # 

