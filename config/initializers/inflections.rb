# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym 'PA'
  inflect.acronym 'TV'
  inflect.acronym 'CAD'
  inflect.acronym '3D'
  inflect.acronym 'CATT'
  inflect.acronym 'CLF'

  # Enable these to keep capitalizations correct in 'titleized' strings
  # However, some models like 'AmxDxlinkDevice' get screwed up when the below
  # are enabled.
  #inflect.acronym 'JBL'
  #inflect.acronym 'BSS'
  #inflect.acronym 'AMX'
  #inflect.acronym 'dbx'

#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end
