require 'resolv'

class BadActorLog < ApplicationRecord
  validates :ip_address, presence: true, format: { with: Resolv::IPv4::Regex }
end
