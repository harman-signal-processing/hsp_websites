# Custom Domain Cookie
#
# Set the cookie domain to the custom domain if it's present
#
# :nocov:
class CustomDomainCookie

  def initialize(app, default_domain)
    @app = app
    @default_domain = default_domain
  end

  def call(env)
    if !!(env["HTTP_HOST"].match(/\:/))
      host = env["HTTP_HOST"].split(':').first
      env["rack.session.options"][:domain] = custom_domain?(host) ? ".#{host}" : "#{@default_domain}"
    end
    @app.call(env)
  end

  def custom_domain?(host)
    host !~ /#{@default_domain.sub(/^\./, '')}/i
  end

end
# :nocov:
