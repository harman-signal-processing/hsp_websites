# These classes are used in conjunction with the redirects.rb file
# in the routes.rb file in order to do site-specific forwarding
# from old URLs to new ones. It is not necessary to add to this file
# if the domain doesn't have any site-specific routing it needs to do.
#
class AmxDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/amx/i))
  end
  # :nocov:
end

class DigitechDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/digitech/i))
  end
  # :nocov:
end

class DodDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/dod/i))
  end
  # :nocov:
end

class DbxDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/dbx/i))
  end
  # :nocov:
end

class LexiconDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/lexicon/i))
  end
  # :nocov:
end

class MartinDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/martin/i))
  end
  # :nocov:
end

class BssDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/bss/i))
  end
  # :nocov:
end

class CrownDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/crown/i))
  end
  # :nocov:
end

class AkgDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/akg/i))
  end
  # :nocov:
end

class JblProDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/jblpro/i))
  end
  # :nocov:
end

class JblCommercialDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/jblcommercial/i))
  end
  # :nocov:
end

class SoundcraftDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/soundcraft/i))
  end
  # :nocov:
end

class StuderDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/studer/i))
  end
  # :nocov:
end

class ToolkitDomain
  # :nocov:
  def self.matches?(request)
    !!(request.host.match(/toolkit/i))
  end
  # :nocov:
end

