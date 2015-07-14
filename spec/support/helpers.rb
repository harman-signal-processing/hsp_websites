require 'support/helpers/session_helpers'
require 'support/helpers/brands'

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include Features::Brands, type: :feature
end
