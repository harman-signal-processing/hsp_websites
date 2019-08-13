# This little hack lets us use the latest version of the country_select gem
# which encourages us to store the country as the 2-letter code instead of
# the name. This is a great idea, but our distributor database is already
# populated with the country names which we need to match.
CountrySelect::FORMATS[:default] = lambda do |country|
  [
    country.name,
    country.name
  ]
end

ISO3166::Data.register(
  alpha2: "TW",
  alpha3: "TWN",
  name: "Taiwan, China",
  translations: {
    'en' => 'Taiwan, China',
    'es' => 'Taiwán, China',
    'de' => 'Taiwan, China',
    'ru' => 'Тайвань, Китай',
    'fr' => 'Taïwan, Chine',
    'zh' => '台湾, 中国'
  },
  continent: "Asia",
	country_code: '886',
	international_prefix: '002',
	ioc: "TPE",
	gec: "TW",
	national_destination_code_lengths: [2],
	national_number_lengths: [7, 8],
	national_prefix: '0',
	number: '158',
	region: "Asia",
	subregion: "Eastern Asia",
	world_region: "APAC",
	un_locode: "TW",
	nationality: "Taiwanese",
	postal_code: true,
	languages_official: ["zh"],
	languages_spoken: ["zh"],
	geo: {
		latitude: 23.69781,
		latitude_dec: '23.685789108276367',
		longitude: 120.960515,
		longitude_dec: '120.89749145507812',
		max_latitude: 26.4545,
		max_longitude: 123.5021012,
		min_latitude: 20.5170001,
		min_longitude: 116.6665,
		bounds: {
			northeast: {
				lat: 26.4545,
				lng: 123.5021012,
			},
			southwest: {
				lat: 20.5170001,
				lng: 116.6665,
			},
		},
	},
	currency_code: "TWD",
	start_of_week: "monday"
)

ISO3166::Data.register(
  alpha2: "HK",
  alpha3: "HKG",
  name: "Hong Kong, China",
  translations: {
    'en' => 'Hong Kong, China',
    'es' => 'Hong Kong, China',
    'de' => 'Hongkong, China',
    'ru' => 'Гонконг, Китай',
    'fr' => 'Hong-Kong, Chine',
    'zh' => '香港, 中国'
  },
	continent: "Asia",
	country_code: '852',
	international_prefix: '001',
	ioc: "HKG",
	gec: "HK",
	national_destination_code_lengths: [2],
	national_number_lengths: [8],
	national_prefix: "None",
	number: '344',
	region: "Asia",
	subregion: "Eastern Asia",
	world_region: "APAC",
	un_locode: "HK",
	nationality: "Hong Kongese",
	postal_code: false,
	languages_official: ["en", "zh"],
	languages_spoken: ["en", "zh"],
	geo: {
		latitude: 22.396428,
		latitude_dec: '22.336156845092773',
		longitude: 114.109497,
		longitude_dec: '114.18696594238281',
		max_latitude: 22.561968,
		max_longitude: 114.4294999,
		min_latitude: 22.1435,
		min_longitude: 113.8259001,
		bounds: {
			northeast: {
				lat: 22.561968,
				lng: 114.4294999,
			},
			southwest: {
				lat: 22.1435,
				lng: 113.8259001,
			},
		},
	},
	currency_code: "HKD",
	start_of_week: "monday"
)

ISO3166::Data.register(
  alpha2: "MO",
  alpha3: "MAC",
  name: "Macao, China",
  translations: {
    en: 'Macao, China',
    es: 'Macao, China',
    de: 'Macao, China',
    ru: 'Аомынь, Китай',
    fr: 'Macau, Chine',
    zh: '澳门, 中国'
  },
  continent: "Asia",
  country_code: 853,
  international_prefix: "00",
  ioc: nil,
  gec: "MC",
  national_destination_code_lengths: [2],
  national_number_lengths: [8],
  national_prefix: 0,
  number: "446",
  region: "Asia",
  subregion: "Eastern Asia",
  world_region: "APAC",
  un_locode: "MO",
  nationality: "Chinese",
  postal_code: false,
  languages_official: ["zh", "pt"],
  languages_spoken: ["zh", "pt"],
  geo: {
		latitude: 22.198745,
    latitude_dec: '22.140748977661133',
    longitude: 113.543873,
    longitude_dec: '113.56034088134766',
    max_latitude: 22.2170639,
    max_longitude: 113.6127001,
    min_latitude: 22.1066001,
    min_longitude: 113.5276053,
    bounds: {
      northeast: {
        lat: 22.2170639,
        lng: 113.6127001,
			},
      southwest: {
        lat: 22.1066001,
        lng: 113.5276053,
      },
    },
  },
  currency_code: "MOP",
  start_of_week: "monday"
)
