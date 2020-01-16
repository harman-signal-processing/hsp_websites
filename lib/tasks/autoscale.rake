#require 'fog'

namespace :rackspace do

  desc "Create an image of the main server and delete old image"
  task :create_image => :environment do
    client = compute_client
    server = client.servers.get("5e3f2121-718f-416c-9a64-e6db31e267af")
    delete_old_images(client, server.name)
    server.create_image("Daily-#{Time.now.to_i}-#{server.name}")
  end

  desc "Update the autoscale settings"
  task :autoscale_update => :environment do
    img = get_most_recent_image_id
    update_autoscale_image(img)
  end

  # The web-based interface adds new servers to the HTTPS load balancer, but since
  # it can only add to one load balancer, we need to manually add new servers to the
  # HTTP load balancer:
  desc "Adds all servers to the HTTP load balancer"
  task :add_to_http_load_balancer => :environment do
    client = compute_client
    balancer = load_balancer_client.load_balancers.get(434547)

    add_servers_to_load_balancer(balancer, client.servers, 2)
  end

  def get_most_recent_image_id
    client = compute_client
    server_name = "HICGLXRAILS2020"
    server_images(client, server_name).sort.last[1]
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

  def delete_old_images(client, server_name)
    images = server_images(client, server_name).sort
    if images.length > 6
      client.images.get(images.first[1]).destroy
    end
  end

  def server_images(client, server_name)
    images =[]
    client.images.all.each do |img|
      if img.name.to_s.match(/#{server_name}/)
        images << [img.created, img.id]
      end
    end
    images
  end

  def add_servers_to_load_balancer(load_balancer, servers, weight=2)
    node_addresses = load_balancer.nodes.map{|n| n.address}

    servers.each do |server|
      server_ip = server.addresses["private"].first["addr"]
      unless node_addresses.include?(server_ip) || server.name.to_s.match?(/temp/i)
        load_balancer.nodes.create(
          address: server_ip,
          port: 80,
          condition: "ENABLED",
          weight: weight
        )
      end
    end
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

  def load_balancer_client
    Fog::Rackspace::LoadBalancers.new(
      rackspace_username: ENV['RACKSPACE_USERNAME'],
      rackspace_api_key: ENV['RACKSPACE_API_KEY'],
      rackspace_region: :ord
    )
  end

  # Use this command to determine the overall CPU usage on the server:
  #
  # echo print `ps -A -o pcpu | tail -n+2 | paste -sd+ | bc `/ `nproc` | python
  #
  # But I probably need to log that number and see if it is something like
  # more than 90% for 2 minutes in a row before scaling up.


end
