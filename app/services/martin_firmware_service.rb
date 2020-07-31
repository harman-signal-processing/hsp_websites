# include HTTParty

module MartinFirmwareService

  class << self

    def get_firmware_data
      url = "#{ENV['MARTIN_FIRMWARE_URL']}"
      response = HTTParty.get(url)
      if response.success?
        result = JSON.parse(response).deep_symbolize_keys
      else
        raise response.message
      end

      result[:firmwarefiles]
    end  #  def get_firmware_data

    def get_firmware_items
      firmware_items = {}
      get_firmware_data.each do |item|
        # name = item[0].to_s
        value_split_on_pipe = item[1].to_s.split("|")
        value_split_on_forward_slash = value_split_on_pipe[0].split("/")

        category = "#{value_split_on_forward_slash[1]} Range"

        firmware_items[category.to_sym] ||= { items: [] }
        firmware_items[category.to_sym][:items] << {
          product: value_split_on_forward_slash[2],
          version: value_split_on_forward_slash[3],
          update_via_usb: value_split_on_pipe[5].to_i > 0,
          update_via_dmx: (value_split_on_pipe[6].present?) ? value_split_on_pipe[6].to_i > 0 : true,
          update_via_p3:  value_split_on_pipe[7].to_i > 0
        }
      end
      firmware_items
    end  # get_firmware_items

    def firmware_items_from_cache
      cache_for = Rails.env.production? ? 1.hour : 1.minute
      Rails.cache.fetch("martin_firmware", expires_in: cache_for, race_condition_ttl: 10) do
        self.get_firmware_items
      end  #  Rails.cache.fetch("martin_firmware", expires_in: cache_for, race_condition_ttl: 10) do
    end

    def firmware_version(product_name)
      version = ""

      firmware_item_group_for_product = firmware_items_from_cache.select{|key, value|
        value[:items].select{|item| item[:product] == product_name }.count > 0
      }  # firmware_items_from_cache.select{|key, value|

      begin
        firmware_items = firmware_item_group_for_product[firmware_item_group_for_product.keys[0]][:items]
        firmware_items_for_product = firmware_items.select{|p| p[:product] == product_name}

        latest_firmware_for_product = latest_product_version_item(firmware_items_for_product)
        version = latest_firmware_for_product[:version]
      rescue => e
      end
      version
    end  #  def firmware_version(product_name)

    def latest_product_version_item(product_version_items)
      highest_version_item = product_version_items.sort_by { |item|
        # Keep only digits and periods in the version number for sorting purposes, also strip any trailing periods
        clean_version = item[:version].delete('^0-9.').gsub(/\.+$/, '')
        Gem::Version.new(clean_version)
      }.reverse!.take(1)

      {
        product: highest_version_item[0][:product],
        version: highest_version_item[0][:version],
        update_via_usb: highest_version_item[0][:update_via_usb],
        update_via_dmx: highest_version_item[0][:update_via_dmx],
        update_via_p3: highest_version_item[0][:update_via_p3]
      }
    end  #  def latest_product_version_item(item)

  end # class << self
end  #  module MartinFirmwareService
