# These classes are used in conjunction with the redirects.rb file
# in the routes.rb file in order to do site-specific forwarding
# from old URLs to new ones. It is not necessary to add to this file
# if the domain doesn't have any site-specific routing it needs to do.
#
class DigitechDomain
  def self.matches?(request)
    !!(request.host.match(/digitech/i))
  end
end

class DodDomain
  def self.matches?(request)
    !!(request.host.match(/dod/i))
  end
end

class DbxDomain
  def self.matches?(request)
    !!(request.host.match(/dbx/i))
  end
end

class LexiconDomain
  def self.matches?(request)
    !!(request.host.match(/lexicon/i))
  end
end

class BssDomain
  def self.matches?(request)
    !!(request.host.match(/bss/i))
  end
end

class CrownDomain
  def self.matches?(request)
    !!(request.host.match(/crown/i))
  end
end

class AkgDomain
  def self.matches?(request)
    !!(request.host.match(/akg/i))
  end
end

class JblProDomain
  def self.matches?(request)
    !!(request.host.match(/jblpro/i))
  end
end

class JblCommercialDomain
  def self.matches?(request)
    !!(request.host.match(/jblcommercial/i))
  end
end

class SoundcraftDomain
  def self.matches?(request)
    !!(request.host.match(/soundcraft/i))
  end
end

class StuderDomain
  def self.matches?(request)
    !!(request.host.match(/studer/i))
  end
end

class ToolkitDomain
  def self.matches?(request)
    !!(request.host.match(/toolkit/i))
  end
end

class QueueDomain
  def self.matches?(request)
    !!(request.host.match(/queue/i))
  end
end

