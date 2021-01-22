require 'spec_helper'

describe Geocodio::Zip4 do
  let(:geocodio) { Geocodio::Client.new }

  subject(:zip4) do
    VCR.use_cassette('geocode_with_zip4') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[zip4]).best.zip4
    end
  end

  it 'has 4-digit plus4 field' do
    expect(zip4.plus4).to eq("1923")
  end

  it 'has 9-digit zip9 field' do
    expect(zip4.zip9).to eq("91105-1923")
  end

end

