# These classes are used in conjunction with the redirects.rb file
# in the routes.rb file in order to do site-specific forwarding
# from old URLs to new ones. It is not necessary to add to this file
# if the domain doesn't have any site-specific routing it needs to do.
#
class DigitechDomain
  def self.matches?(request)
    !!(request.host.match(/digitech\.com/i) || request.host.match(/digitech\.lvh\.me/i))
  end
end

class HardwireDomain
  def self.matches?(request)
    !!(request.host.match(/hardwirepedals\.com|hwtest/i)) # for testing: || request.host.match(/lvh\.me/i))
  end
end

class VocalistDomain
  def self.matches?(request)
    !!(request.host.match(/vocalistpro\.com|voctest/i))
  end
end

class DbxDomain
  def self.matches?(request)
    !!(request.host.match(/dbxpro\.com|dbxtest/i))
  end
end

class LexiconDomain
  def self.matches?(request)
    !!(request.host.match(/lexiconpro\.com/i))
  end
end

class BssDomain
  def self.matches?(request)
    !!(request.host.match(/bssaudio\.com/i) || request.host.match(/bss\.co\.uk/i))
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

