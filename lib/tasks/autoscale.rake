require 'fog'

namespace :rackspace do

  desc "Update the autoscale settings"
  task :autoscale_update => :environment do
    img = get_most_recent_image_id
    update_autoscale_image(img)
  end

  def get_most_recent_image_id
    client = compute_client

    daily_images = []
    client.images.all.each do |img|
      if img.name.to_s.match(/HICGLXRAILS/)
        daily_images << [img.created, img.id]
      end
    end

    daily_images.sort.last[1]
  end

  def update_autoscale_image(image_id)
    client = autoscale_client

    service_group = client.groups.first
    launch_config = service_group.launch_config

    args = launch_config.args
    args["server"]["imageRef"] = image_id

    launch_config.args = args
    launch_config.save
  end

  # Use this command to determine the overall CPU usage on the server:
  #
  # echo print `ps -A -o pcpu | tail -n+2 | paste -sd+ | bc `/ `nproc` | python
  #
  # But I probably need to log that number and see if it is something like
  # more than 90% for 2 minutes in a row before scaling up.

  desc "Create an image of the main server"
  task :create_image => :environment do
    client = compute_client
    server = client.servers.find(name: "HICGLXRAILS02").first
    server.create_image(name: "Daily-#{Time.now.to_i}-HICGLXRAILS02")
  end

  def autoscale_client
    Fog::Rackspace::AutoScale.new(
      rackspace_username: ENV['RACKSPACE_USERNAME'],
      rackspace_api_key: ENV['RACKSPACE_API_KEY'],
      rackspace_region: :ord
    )
  end

  def compute_client
    Fog::Compute.new(
      provider: 'rackspace',
      rackspace_username: ENV['RACKSPACE_USERNAME'],
      rackspace_api_key: ENV['RACKSPACE_API_KEY'],
      rackspace_region: :ord
    )
  end

end
