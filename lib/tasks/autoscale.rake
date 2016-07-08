require 'fog'

namespace :rackspace do

  desc "Update the autoscale settings"
  task :autoscale_update => :environment do
    img = get_most_recent_image_id
    update_autoscale_image(img)
  end

  def get_most_recent_image_id
    client = Fog::Compute.new(
      provider: 'rackspace',
      rackspace_username: ENV['RACKSPACE_USERNAME'],
      rackspace_api_key: ENV['RACKSPACE_API_KEY'],
      rackspace_region: :ord
    )

    daily_images = []
    client.images.all.each do |img|
      if img.name.to_s.match(/HICGLXRAILS/)
        daily_images << [img.created, img.id]
      end
    end

    daily_images.sort.last[1]
  end

  def update_autoscale_image(image_id)
    client = Fog::Rackspace::AutoScale.new(
      rackspace_username: ENV['RACKSPACE_USERNAME'],
      rackspace_api_key: ENV['RACKSPACE_API_KEY'],
      rackspace_region: :ord
    )

    service_group = client.groups.first
    launch_config = service_group.launch_config

    args = launch_config.args
    args["server"]["imageRef"] = image_id

    launch_config.args = args
    launch_config.save
  end

end
