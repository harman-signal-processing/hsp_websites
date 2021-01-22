module Geocodio
  class Zip4
    attr_reader :plus4
    attr_reader :zip9

    def initialize(payload = {})
      @plus4 = payload['plus4'].first
      @zip9  = payload['zip9'].first
    end
  end
end
