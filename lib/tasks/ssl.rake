namespace :rackspace do

  desc "Update all SSL certs on load balancers"
  task :update_ssl_certs => :environment do
    client = load_balancer_client

    cert_folder = "/etc/letsencrypt/load_balancers/"

    Dir.entries(cert_folder).each do |balancer_id|
      if balancer_id.to_s.match(/^\d*$/)

        privkey = File.read(File.join(cert_folder, balancer_id, "privkey.pem"))
        cert = File.read(File.join(cert_folder, balancer_id, "cert.pem"))
        chain = File.read(File.join(cert_folder, balancer_id, "chain.pem"))

        balancer = client.load_balancers.get(balancer_id)
        puts "  Updating load balancer: #{ balancer.name }"

        balancer.enable_ssl_termination(
          "443", privkey, cert, intermediate_certificate: chain
        )
      end
    end
  end

  def load_balancer_client
    Fog::Rackspace::LoadBalancers.new(
      rackspace_username: ENV['RACKSPACE_USERNAME'],
      rackspace_api_key: ENV['RACKSPACE_API_KEY'],
      rackspace_region: :ord
    )
  end

end
