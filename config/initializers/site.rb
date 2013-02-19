# The hostname for the Marketing Toolkit (used in mailers)
TOOLKIT_HOST = "hsptoolkit.harmanpro.com"

# The hostname for the fantastic RSO site (Regional Sales Office)
RSO_HOST = "rso.digitech.com"

# The ID from the database for this site's brand. If you only have one brand,
# create that one brand in the database (see /db/seeds.rb) and provide its ID
# from the database here.
#
# If you have multiple brands, then you _can_ use a *copy* of this site's code
# to run multiple sites off the same database. Just be sure to set the website.brand_id
# appropriately for each site.
#
## NOTE: This setting is now ignored in production. Instead it uses the Websites
## table to decipher the brand from the URL, but it is used in dev/test
BRAND_ID = 1

# Override the SITE_NAME by creating a Setting (/admin/settings) named "site_name".
# The SITE_NAME below is only used if there is no Setting named "site_name". If 
# poses a problem for you (running multiple sites from the same database), then
# consider hosting the "Settings" table in a different database store than the
# rest of the site. This way you can have one for each brand.
#
SITE_NAME = "Harman Signal Processing" 

# The different types of documents that can be associated with a product. Make 
# sure there's a corresponding entry in each config/locales YAML file.
#
DOCUMENT_TYPES = [
  ["Owner's Manual", "owners_manual"],
  ["Cut Sheet", "cut_sheet"],
  ["Quickstart Guide", "quickstart_guide"],
  ["Application Guide", "application_guide"],
  ["Install Guide", "install_guide"],
  ["Preset List", "preset_list"],
  ["Schematic", "schematic"],
  ["Service Manual", "service_manual"],
  ["Parts List", "parts_list"],
  ["Calibration Procedure", "calibration_procedure"],
  ["CAD Files", "cad_files"],
  ["CAD Drawing front", "cad_drawing_front"],
  ["CAD Drawing rear", "cad_drawing_rear"],
  ["Brochure", "brochure"],
  ["Other", "other"]
]

# The languages available for the above document types
#
DOCUMENT_LANGUAGES = [
  ["English", "en"],
  ["Chinese", "zh"],
  ["Spanish", "es"],
  ["French", "fr"],
  ["German", "de"]
]

if Rails.env.production?
  DEFAULT_FROM = "support@digitech.com"
  DEFAULT_TO = "support@digitech.com"
else
  DEFAULT_FROM = "adam.anderson@harman.com"
  DEFAULT_TO = "adam.anderson@harman.com"
end
